OBJECT Page 902 Assembly Orders
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
    CaptionML=[DAN=Montageordrer;
               ENU=Assembly Orders];
    SourceTable=Table900;
    SourceTableView=WHERE(Document Type=FILTER(Order));
    DataCaptionFields=No.;
    PageType=List;
    CardPageID=Assembly Order;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 32      ;1   ;ActionGroup;
                      Name=Line;
                      CaptionML=[DAN=Linje;
                                 ENU=Line];
                      Image=Line }
      { 13      ;2   ;ActionGroup;
                      Name=Entries;
                      CaptionML=[DAN=Poster;
                                 ENU=Entries];
                      ActionContainerType=NewDocumentItems;
                      Image=Entries }
      { 12      ;3   ;Action    ;
                      Name=Item Ledger Entries;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Vareposter;
                                 ENU=Item Ledger E&ntries];
                      ToolTipML=[DAN=Vis vareposterne for varen pÜ bilaget eller kladdelinjen.;
                                 ENU=View the item ledger entries of the item on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 38;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=ItemLedger }
      { 11      ;3   ;Action    ;
                      Name=Capacity Ledger Entries;
                      CaptionML=[DAN=Kapacitetsposter;
                                 ENU=Capacity Ledger Entries];
                      ToolTipML=[DAN=Vis kapacitetsposterne for den involverede produktionsordre. Kapaciteten registreres enten som tid (operationstid, stoptid eller opstillingstid) eller som antal (spildantal eller afgangsantal).;
                                 ENU=View the capacity ledger entries of the involved production order. Capacity is recorded either as time (run time, stop time, or setup time) or as quantity (scrap quantity or output quantity).];
                      ApplicationArea=#Manufacturing;
                      RunObject=Page 5832;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=CapacityLedger }
      { 10      ;3   ;Action    ;
                      Name=Resource Ledger Entries;
                      CaptionML=[DAN=Ressourceposter;
                                 ENU=Resource Ledger Entries];
                      ToolTipML=[DAN=Vis poster for ressourcen.;
                                 ENU=View the ledger entries for the resource.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 202;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=ResourceLedger }
      { 9       ;3   ;Action    ;
                      Name=Value Entries;
                      CaptionML=[DAN=Vërdiposter;
                                 ENU=Value Entries];
                      ToolTipML=[DAN=Vis vërdiposterne for varen pÜ bilags- eller kladdelinjen.;
                                 ENU=View the value entries of the item on the document or journal line.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 5802;
                      RunPageView=SORTING(Order Type,Order No.);
                      RunPageLink=Order Type=CONST(Assembly),
                                  Order No.=FIELD(No.);
                      Image=ValueLedger }
      { 28      ;3   ;Action    ;
                      Name=Warehouse Entries;
                      CaptionML=[DAN=&Lagerposter;
                                 ENU=&Warehouse Entries];
                      ToolTipML=[DAN="FÜ vist historikken over antal, der er registreret for varen under lageraktiviteter. ";
                                 ENU="View the history of quantities that are registered for the item in warehouse activities. "];
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7318;
                      RunPageView=SORTING(Source Type,Source Subtype,Source No.);
                      RunPageLink=Source Type=FILTER(83|901),
                                  Source Subtype=FILTER(1|6),
                                  Source No.=FIELD(No.);
                      Image=BinLedger }
      { 33      ;2   ;Action    ;
                      Name=Show Order;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Vis ordrer;
                                 ENU=Show Order];
                      ToolTipML=[DAN=Vis den valgte montageordre.;
                                 ENU=View the selected assembly order.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 900;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  No.=FIELD(No.);
                      Image=ViewOrder }
      { 40      ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      ActionContainerType=NewDocumentItems;
                      Image=ItemAvailability }
      { 39      ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilgëngelige saldo for en vare udvikler sig over tid i henhold til udbud og efterspõrgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Assembly;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 38      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller mÜned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Assembly;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 37      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Assembly;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 36      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 35      ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=FÜ vist tilgëngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret pÜ tilgëngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmHeader(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Statistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=FÜ vist statistiske oplysninger om recorden, f.eks. vërdien af bogfõrte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 916;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Image=Statistics }
      { 5       ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omrÜde, projekt eller afdeling, som du kan tildele til salgs- og kõbsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 4       ;2   ;Action    ;
                      Name=Assembly BOM;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=FÜ vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der krëves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 36;
                      RunPageLink=Parent Item No.=FIELD(Item No.);
                      Image=AssemblyBOM }
      { 3       ;2   ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  Document No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 19      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 26      ;1   ;ActionGroup;
                      Name=F&unctions;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      ActionContainerType=ActionItems;
                      Image=Action }
      { 27      ;2   ;Action    ;
                      Name=Release;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=F&rigiv;
                                 ENU=Re&lease];
                      ToolTipML=[DAN=Frigiv bilaget til nëste behandlingstrin. NÜr et bilag frigives, bliver det inkluderet i alle disponeringsberegninger fra den dato, varerne forventes modtaget. Du skal genÜbne bilaget, fõr du kan foretage ëndringer i det.;
                                 ENU=Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.];
                      ApplicationArea=#Assembly;
                      Image=ReleaseDoc;
                      OnAction=VAR
                                 AssemblyHeader@1000 : Record 900;
                               BEGIN
                                 AssemblyHeader := Rec;
                                 AssemblyHeader.FIND;
                                 CODEUNIT.RUN(CODEUNIT::"Release Assembly Document",AssemblyHeader);
                               END;
                                }
      { 31      ;2   ;Action    ;
                      Name=Reopen;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn bilaget igen ved ekstra lageraktivitet.;
                                 ENU=Reopen the document for additional warehouse activity.];
                      ApplicationArea=#Assembly;
                      Image=ReOpen;
                      OnAction=VAR
                                 AssemblyHeader@1000 : Record 900;
                                 ReleaseAssemblyDoc@1001 : Codeunit 903;
                               BEGIN
                                 AssemblyHeader := Rec;
                                 AssemblyHeader.FIND;
                                 ReleaseAssemblyDoc.Reopen(AssemblyHeader);
                               END;
                                }
      { 15      ;1   ;ActionGroup;
                      Name=P&osting;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&osting];
                      ActionContainerType=ActionItems;
                      Image=Post }
      { 14      ;2   ;Action    ;
                      Name=P&ost;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogfõring;
                                 ENU=P&ost];
                      ToolTipML=[DAN=Fërdiggõr bilaget eller kladden ved at bogfõre belõb og antal pÜ de relaterede konti i regnskaberne.;
                                 ENU=Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Assembly-Post (Yes/No)",Rec);
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=Post &Batch;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Massebogfõr;
                                 ENU=Post &Batch];
                      ToolTipML=[DAN=Bogfõr flere bilag pÜ Çn gang. Der Übnes et anmodningsvindue, hvor du kan angive, hvilke bilag der skal bogfõres.;
                                 ENU=Post several documents at once. A report request window opens where you can specify which documents to post.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=PostBatch;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 REPORT.RUNMODAL(REPORT::"Batch Post Assembly Orders",TRUE,TRUE,Rec);
                                 CurrPage.UPDATE(FALSE);
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

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver montagedokumenttypen, som recorden reprësenterer i ordremontagescenarier.;
                           ENU=Specifies the type of assembly document the record represents in assemble-to-order scenarios.];
                ApplicationArea=#Assembly;
                SourceExpr="Document Type" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af montageelementet.;
                           ENU=Specifies the description of the assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageelementet skal vëre tilgëngeligt.;
                           ENU=Specifies the date when the assembled item is due to be available for use.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at starte.;
                           ENU=Specifies the date when the assembly order is expected to start.];
                ApplicationArea=#Assembly;
                SourceExpr="Starting Date" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at slutte.;
                           ENU=Specifies the date when the assembly order is expected to finish.];
                ApplicationArea=#Assembly;
                SourceExpr="Ending Date" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om montageordren er knyttet til en salgsordre, som angiver, at elementet er monteret under en ordre.;
                           ENU=Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den vare, der er ved at blive monteret med montageordren.;
                           ENU=Specifies the number of the item that is being assembled with the assembly order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, du forventer at montere med montageordren.;
                           ENU=Specifies how many units of the assembly item that you expect to assemble with the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, pÜ Çn enhed af varen eller ressourcen pÜ linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogfõre afgangen af montageelementet for.;
                           ENU=Specifies the location to which you want to post output of the assembly item.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant pÜ linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Variant Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, som montageelementet er bogfõrt for, som afgang, Her hentes det til lager eller afsendes, hvis det monteres under en salgsordre.;
                           ENU=Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, der mangler at blive bogfõrt som monteret afgang.;
                           ENU=Specifies how many units of the assembly item remain to be posted as assembled output.];
                ApplicationArea=#Assembly;
                SourceExpr="Remaining Quantity" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                CaptionML=[DAN=Recordlinks;
                           ENU=RecordLinks];
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
      ItemAvailFormsMgt@1000 : Codeunit 353;

    BEGIN
    END.
  }
}

