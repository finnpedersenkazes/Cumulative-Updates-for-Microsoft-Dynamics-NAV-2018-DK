OBJECT Page 99000868 Finished Prod. Order Lines
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
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table5406;
    SourceTableView=WHERE(Status=CONST(Finished));
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       DescriptionIndent := 0;
                       DescriptionOnFormat;
                     END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907935204;1 ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 1901288104;2 ;Action    ;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Dimensions;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 1903098604;2 ;Action    ;
                      CaptionML=[DAN=R&ute;
                                 ENU=Ro&uting];
                      ToolTipML=[DAN=F† vist eller rediger operationslisten for den overordnede vare p† linjen.;
                                 ENU=View or edit the operations list of the parent item on the line.];
                      ApplicationArea=#Manufacturing;
                      Image=Route;
                      OnAction=BEGIN
                                 ShowRouting;
                               END;
                                }
      { 1901991404;2 ;Action    ;
                      CaptionML=[DAN=Komponenter;
                                 ENU=Components];
                      ToolTipML=[DAN=F† vist eller rediger produktionsordrekomponenterne for den overordnede vare p† linjen.;
                                 ENU=View or edit the production order components of the parent item on the line.];
                      ApplicationArea=#Manufacturing;
                      Image=Components;
                      OnAction=BEGIN
                                 ShowComponents;
                               END;
                                }
      { 1905987604;2 ;Action    ;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 OpenItemTrackingLines;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=DescriptionIndent;
                IndentationControls=Description;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der skal produceres.;
                           ENU=Specifies the number of the item that is to be produced.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen, hvor den producerede vare skal v‘re tilg‘ngelig. Datoen kopieres fra hovedet p† produktionsordren.;
                           ENU=Specifies the date when the produced item must be available. The date is copied from the header of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘rdien i feltet Beskrivelse p† varekortet. Hvis du angiver en variantkode, kopieres variantbeskrivelsen til feltet i stedet for.;
                           ENU=Specifies the value of the Description field on the item card. If you enter a variant code, the variant description is copied to this field instead.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en ekstra beskrivelse.;
                           ENU=Specifies an additional description.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den produktionsstykliste, der er grundlaget for oprettelse af produktionsordrekomponentlisten for denne linje.;
                           ENU=Specifies the number of the production BOM that is the basis for creating the Prod. Order Component list for this line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production BOM No.";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den rute, der bruges som grundlag for oprettelse af produktionsordreruten for linjen.;
                           ENU=Specifies the number of the routing used as the basis for creating the production order routing for this line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No.";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionsnummeret p† ruten.;
                           ENU=Specifies the version number of the routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Version Code";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver versionskoden for produktionsstyklisten.;
                           ENU=Specifies the version code of the production BOM.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production BOM Version Code";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationskoden, hvis de producerede varer skal opbevares p† en bestemt lokation.;
                           ENU=Specifies the location code, if the produced items should be stored in a specific location.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, som den producerede vare bogf›res til som afgang, og hvorfra den kan l‘gges p† lager eller afsendes direkte.;
                           ENU=Specifies the bin that the produced item is posted to as output, and from where it can be taken to storage or cross-docked.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Startdato/tidspunkt.;
                           ENU=Specifies the starting date and the starting time, which are combined in a format called "starting date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date-Time" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens startklokkesl‘t, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's starting time, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens startdato, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's starting date, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Slutdato/tidspunkt.;
                           ENU=Specifies the ending date and the ending time, which are combined in a format called "ending date-time".];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date-Time" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens slutklokkesl‘t, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's ending time, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Time";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postens slutdato, som hentes fra produktionsordreruten.;
                           ENU=Specifies the entry's ending date, which is retrieved from the production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer g†r til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal, der skal produceres, hvis du udfylder linjen manuelt.;
                           ENU=Specifies the quantity to be produced if you manually fill in this line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Quantity }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor stor en del af antallet p† linjen der er produceret.;
                           ENU=Specifies how much of the quantity on this line has been produced.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Finished Quantity" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den totale pris p† linjen ved at multiplicere kostprisen med antallet.;
                           ENU=Specifies the total cost on the line by multiplying the unit cost by the quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Cost Amount" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      DescriptionIndent@19057867 : Integer INDATASET;

    LOCAL PROCEDURE ShowComponents@1();
    VAR
      ProdOrderComp@1000 : Record 5407;
    BEGIN
      ProdOrderComp.SETRANGE(Status,Status);
      ProdOrderComp.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderComp.SETRANGE("Prod. Order Line No.","Line No.");

      PAGE.RUN(PAGE::"Prod. Order Components",ProdOrderComp);
    END;

    LOCAL PROCEDURE ShowRouting@2();
    VAR
      ProdOrderRtngLine@1000 : Record 5409;
    BEGIN
      ProdOrderRtngLine.SETRANGE(Status,Status);
      ProdOrderRtngLine.SETRANGE("Prod. Order No.","Prod. Order No.");
      ProdOrderRtngLine.SETRANGE("Routing Reference No.","Routing Reference No.");
      ProdOrderRtngLine.SETRANGE("Routing No.","Routing No.");

      PAGE.RUN(PAGE::"Prod. Order Routing",ProdOrderRtngLine);
    END;

    LOCAL PROCEDURE OpenItemTrackingLines@6500();
    BEGIN
      OpenItemTrackingLines;
    END;

    LOCAL PROCEDURE DescriptionOnFormat@19023855();
    BEGIN
      DescriptionIndent := "Planning Level Code";
    END;

    BEGIN
    END.
  }
}

