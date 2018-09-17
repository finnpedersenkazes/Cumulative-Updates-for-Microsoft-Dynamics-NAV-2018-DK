OBJECT Page 99000861 Planning Component List
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
    CaptionML=[DAN=Planl‘gning - komponentliste;
               ENU=Planning Component List];
    SourceTable=Table99000829;
    DataCaptionExpr=Caption;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 2       ;1   ;ActionGroup;
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

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varenummeret for komponenten.;
                           ENU=Specifies the item number of the component.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No.";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor planl‘gningskomponenten skal v‘re afsluttet.;
                           ENU=Specifies the date when this planning component must be finished.];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af komponenten.;
                           ENU=Specifies the description of the component.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer g†r til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %";
                Visible=FALSE }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan feltet Antal bliver beregnet.;
                           ENU=Specifies how to calculate the Quantity field.];
                ApplicationArea=#Planning;
                SourceExpr="Calculation Formula" }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the length of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Length }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bredden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the width of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Width }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘gten af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the weight of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Weight }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dybden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the depth of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Depth }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten der kr‘ves for at producere den overordnede vare.;
                           ENU=Specifies how many units of the component are required to produce the parent item.];
                ApplicationArea=#Advanced;
                SourceExpr="Quantity per" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forventede antal for planl‘gningskomponentlinjen.;
                           ENU=Specifies the expected quantity of this planning component line.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Quantity" }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver indholdet af feltet Forventet antal p† linjen, anf›rt i basisenheder.;
                           ENU=Specifies the contents of the Expected Quantity field on the line, in base units of measure.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Quantity (Base)" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lagerlokation, hvor varen p† planl‘gningskomponentlinjen skal registreres.;
                           ENU=Specifies the code for the inventory location, where the item on the planning component line will be registered.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en rutebindingskode for at knytte en planl‘gningskomponent til en bestemt operation.;
                           ENU=Specifies a routing link code to link a planning component with a specific operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Link Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for planl‘gningskomponentlinjen.;
                           ENU=Specifies the total cost for this planning component line.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position p† styklisten.;
                           ENU=Specifies the position of the component on the bill of material.];
                ApplicationArea=#Advanced;
                SourceExpr=Position;
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det andet referencenummer for komponentens position, f.eks. det alternative positionsnummer for en komponent p† en printplade.;
                           ENU=Specifies the second reference number for the component position, such as the alternate position number of a component on a circuit board.];
                ApplicationArea=#Advanced;
                SourceExpr="Position 2";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tredje referencenummer for komponentens position p† en stykliste, f.eks. det alternative positionsnummer for en komponent p† en printplade.;
                           ENU=Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.];
                ApplicationArea=#Advanced;
                SourceExpr="Position 3";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver genneml›bstiden for planl‘gningskomponenten.;
                           ENU=Specifies the lead-time offset for the planning component.];
                ApplicationArea=#Advanced;
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

    BEGIN
    END.
  }
}

