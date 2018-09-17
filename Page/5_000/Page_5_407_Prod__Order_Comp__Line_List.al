OBJECT Page 5407 Prod. Order Comp. Line List
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
    CaptionML=[DAN=Prod.o.forbrugslinjeoversigt;
               ENU=Prod. Order Comp. Line List];
    SourceTable=Table5407;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       ShowShortcutDimCode(ShortcutDimCode);
                     END;

    OnNewRecord=BEGIN
                  CLEAR(ShortcutDimCode);
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 6500    ;2   ;Action    ;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for den produktionsordre, som komponentlisten tilh›rer.;
                           ENU=Specifies the status of the production order to which the component list belongs.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Status }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede produktionsordre.;
                           ENU=Specifies the number of the related production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den produktionsordrelinje, som komponentlisten tilh›rer.;
                           ENU=Specifies the number of the production order line to which the component list belongs.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Prod. Order Line No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der indg†r som komponent p† produktionsordrekomponentlisten.;
                           ENU=Specifies the number of the item that is a component in the production order component list.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Item No." }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af varen p† linjen.;
                           ENU=Specifies a description of the item on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 300 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[3];
                CaptionClass='1,2,3';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(3),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 302 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[4];
                CaptionClass='1,2,4';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(4),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 304 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[5];
                CaptionClass='1,2,5';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(5),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 306 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[6];
                CaptionClass='1,2,6';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(6),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 308 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[7];
                CaptionClass='1,2,7';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(7),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 310 ;2   ;Field     ;
                ApplicationArea=#Dimensions;
                SourceExpr=ShortcutDimCode[8];
                CaptionClass='1,2,8';
                TableRelation="Dimension Value".Code WHERE (Global Dimension No.=CONST(8),
                                                            Dimension Value Type=CONST(Standard),
                                                            Blocked=CONST(No));
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver lokationen, hvor komponenten gemmes. Kopierer lokationskoden fra det tilsvarende felt i produktionsordrelinjen.;
                           ENU=Specifies the location where the component is stored. Copies the location code from the corresponding field on the production order line.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Visible=TRUE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten der kr‘ves for at producere den overordnede vare.;
                           ENU=Specifies how many units of the component are required to produce the parent item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Quantity per" }

    { 57  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af komponenter, som forventes at blive forbrugt i produktionen af antallet p† linjen.;
                           ENU=Specifies the quantity of the component expected to be consumed during the production of the quantity on this line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Expected Quantity" }

    { 59  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forskellen mellem det f‘rdige og det planlagte antal, eller angiver 0, hvis det f‘rdige antal overstiger restantallet.;
                           ENU=Specifies the difference between the finished and planned quantities, or zero if the finished quantity is greater than the remaining quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Remaining Quantity" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen, hvor den producerede vare skal v‘re tilg‘ngelig. Datoen kopieres fra hovedet p† produktionsordren.;
                           ENU=Specifies the date when the produced item must be available. The date is copied from the header of the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Due Date" }

    { 61  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den totale pris p† linjen ved at multiplicere kostprisen med antallet.;
                           ENU=Specifies the total cost on the line by multiplying the unit cost by the quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Cost Amount";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position p† styklisten.;
                           ENU=Specifies the position of the component on the bill of material.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Position;
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position i styklisten. Den kopieres fra produktionsstyklisten, n†r du beregner produktionsordren.;
                           ENU=Specifies the components position in the BOM. It is copied from the production BOM when you calculate the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Position 2";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tredje referencenummer for komponentens position p† en stykliste, f.eks. det alternative positionsnummer for en komponent p† en printplade.;
                           ENU=Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Position 3";
                Visible=FALSE }

    { 63  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver genneml›bstiden for komponentlinjen. Den kopieres fra det tilsvarende felt i produktionsstyklisten, n†r du beregner produktionsordren.;
                           ENU=Specifies the lead-time offset for the component line. It is copied from the corresponding field in the production BOM when you calculate the production order.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Lead-Time Offset";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
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
      ShortcutDimCode@1000 : ARRAY [8] OF Code[20];

    BEGIN
    END.
  }
}

