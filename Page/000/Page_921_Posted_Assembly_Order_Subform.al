OBJECT Page 921 Posted Assembly Order Subform
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
    CaptionML=[DAN=Bogf›rt montageordreunderform;
               ENU=Posted Assembly Order Subform];
    SourceTable=Table911;
    PageType=ListPart;
    ActionList=ACTIONS
    {
      { 28      ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 13      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      ActionContainerType=ActionItems;
                      Image=Line }
      { 29      ;2   ;Action    ;
                      Name=Dimensions;
                      AccessByPermission=TableData 348=R;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner;
                                 ENU=Dimensions];
                      ToolTipML=[DAN=Vis eller rediger dimensioner, f.eks. omr†de, projekt eller afdeling, som du kan tildele til salgs- og k›bsdokumenter for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.];
                      ApplicationArea=#Suite;
                      Image=Dimensions;
                      OnAction=BEGIN
                                 ShowDimensions;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=Item &Tracking Lines;
                      ShortCutKey=Shift+Ctrl+I;
                      CaptionML=[DAN=Vare&sporingslinjer;
                                 ENU=Item &Tracking Lines];
                      ToolTipML=[DAN=Vis eller rediger serienummer og lotnumre, der er tildelt varen p† bilags- eller kladdelinjen.;
                                 ENU=View or edit serial numbers and lot numbers that are assigned to the item on the document or journal line.];
                      ApplicationArea=#ItemTracking;
                      Image=ItemTrackingLines;
                      OnAction=BEGIN
                                 ShowItemTrackingLines;
                               END;
                                }
      { 30      ;2   ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=CONST(Posted Assembly),
                                  Document No.=FIELD(Document No.),
                                  Document Line No.=FIELD(Line No.);
                      Image=ViewComments }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den montageordrelinje, som den bogf›rte montageordrelinje stammer fra.;
                           ENU=Specifies the number of the assembly order line that the posted assembly order line originates from.];
                ApplicationArea=#Assembly;
                SourceExpr="Order Line No.";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den bogf›rte montageordrelinje er af typen Vare eller Ressource.;
                           ENU=Specifies if the posted assembly order line is of type Item or Resource.];
                ApplicationArea=#Assembly;
                SourceExpr=Type }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af montagekomponenten p† den bogf›rte montagelinje.;
                           ENU=Specifies the description of the assembly component on the posted assembly line.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anden beskrivelse af montagekomponenten p† den bogf›rte montagelinje.;
                           ENU=Specifies the second description of the assembly component on the posted assembly line.];
                ApplicationArea=#Assembly;
                SourceExpr="Description 2";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, fra hvilken lokation montagekomponenten blev forbrugt p† denne bogf›rte montageordrelinje.;
                           ENU=Specifies from which location the assembly component was consumed on this posted assembly order line.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der blev bogf›rt som forbrugt af den bogf›rte montageordrelinje.;
                           ENU=Specifies how many units of the assembly component were posted as consumed by the posted assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der kr‘ves for at samle et montageelement.;
                           ENU=Specifies how many units of the assembly component are required to assemble one assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Quantity per" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, fra hvilken placering montagekomponenten blev forbrugt p† den bogf›rte montageordrelinje.;
                           ENU=Specifies from which bin the assembly component was consumed on the posted assembly order line.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til varen, og en lagerkonto i finansposterne for at samle bel›bene for denne varetype i en gruppe.;
                           ENU=Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.];
                ApplicationArea=#Assembly;
                SourceExpr="Inventory Posting Group";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for den bogf›rte montageordrelinje.;
                           ENU=Specifies the cost of the posted assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Cost Amount" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet pr. enhed for komponentvaren p† den bogf›rte montageordrelinje.;
                           ENU=Specifies the quantity per unit of measure of the component item on the posted assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. per Unit of Measure" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kostprisen p† ressourcen p† den bogf›rte montageordrelinje tildeles montageelementet.;
                           ENU=Specifies how the cost of the resource on the posted assembly order line is allocated to the assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Resource Usage Type" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

