OBJECT Page 99000862 Planning Components
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Planl‘gning - komponenter;
               ENU=Planning Components];
    MultipleNewLines=Yes;
    SourceTable=Table99000829;
    DataCaptionExpr=Caption;
    DelayedInsert=Yes;
    PageType=List;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Ko&mponent;
                                 ENU=&Component];
                      Image=Components }
      { 40      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 7       ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPlanningComp(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 15      ;3   ;Action    ;
                      CaptionML=[DAN=&Periode;
                                 ENU=&Period];
                      ToolTipML=[DAN=Vis, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikles over tid.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time.];
                      ApplicationArea=#Planning;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPlanningComp(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 20      ;3   ;Action    ;
                      CaptionML=[DAN=&Variant;
                                 ENU=&Variant];
                      ToolTipML=[DAN=F† vist eventuelle varianter af varen.;
                                 ENU=View any variants that exist for the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPlanningComp(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 21      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=&Lokation;
                                 ENU=&Location];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om den lokation, hvor komponenten findes.;
                                 ENU=View detailed information about the location where the component exists.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPlanningComp(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 9       ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromPlanningComp(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 22      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 23      ;2   ;Action    ;
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
                                 CurrPage.SAVERECORD;
                               END;
                                }
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
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 2       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 4       ;2   ;Action    ;
                      CaptionML=[DAN=&Reserver;
                                 ENU=&Reserve];
                      ToolTipML=[DAN=Reserver den n›dvendige m‘ngde p† den bilagslinje, som vinduet blev †bnet for.;
                                 ENU=Reserve the quantity that is required on the document line that you opened this window for.];
                      ApplicationArea=#Advanced;
                      Image=Reserve;
                      OnAction=BEGIN
                                 CurrPage.SAVERECORD;
                                 ShowReservation;
                               END;
                                }
      { 3       ;2   ;Action    ;
                      Name=OrderTracking;
                      CaptionML=[DAN=Ordre&sporing;
                                 ENU=Order &Tracking];
                      ToolTipML=[DAN=Sporer forbindelsen mellem udbud og den dertil h›rende eftersp›rgsel. P† denne m†de kan du finde den oprindelige eftersp›rgsel, der medf›rte en specifik produktionsordre eller k›bsordre.;
                                 ENU=Tracks the connection of a supply to its corresponding demand. This can help you find the original demand that created a specific production order or purchase order.];
                      ApplicationArea=#ItemTracking;
                      Image=OrderTracking;
                      OnAction=VAR
                                 TrackingForm@1001 : Page 99000822;
                               BEGIN
                                 TrackingForm.SetPlanningComponent(Rec);
                                 TrackingForm.RUNMODAL;
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

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varenummeret for komponenten.;
                           ENU=Specifies the item number of the component.];
                ApplicationArea=#Advanced;
                SourceExpr="Item No." }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver forfaldsdatoen og -klokkesl‘ttet i et kombineret format, der kaldes Forfaldsdato/tidspunkt.;
                           ENU=Specifies the due date and the due time, which are combined in a format called "due date-time".];
                ApplicationArea=#Advanced;
                SourceExpr="Due Date-Time";
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

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer g†r til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan feltet Antal bliver beregnet.;
                           ENU=Specifies how to calculate the Quantity field.];
                ApplicationArea=#Planning;
                SourceExpr="Calculation Formula";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the length of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Length;
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bredden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the width of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Width;
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dybden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the depth of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Depth;
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘gten af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the weight of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Advanced;
                SourceExpr=Weight;
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten der kr‘ves for at producere den overordnede vare.;
                           ENU=Specifies how many units of the component are required to produce the parent item.];
                ApplicationArea=#Advanced;
                SourceExpr="Quantity per" }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit of Measure Code" }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det forventede antal for planl‘gningskomponentlinjen.;
                           ENU=Specifies the expected quantity of this planning component line.];
                ApplicationArea=#Advanced;
                SourceExpr="Expected Quantity" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af enheder, der er reserveret.;
                           ENU=Specifies the quantity of units that are reserved.];
                ApplicationArea=#Advanced;
                SourceExpr="Reserved Quantity";
                Visible=FALSE;
                OnDrillDown=BEGIN
                              ShowReservationEntries(TRUE);
                            END;
                             }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=FALSE }

    { 60  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Dimensions;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=FALSE }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en rutebindingskode for at knytte en planl‘gningskomponent til en bestemt operation.;
                           ENU=Specifies a routing link code to link a planning component with a specific operation.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Link Code";
                Visible=FALSE }

    { 64  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den lagerlokation, hvor varen p† planl‘gningskomponentlinjen skal registreres.;
                           ENU=Specifies the code for the inventory location, where the item on the planning component line will be registered.];
                ApplicationArea=#Advanced;
                SourceExpr="Location Code";
                Visible=FALSE }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Unit Cost" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostbel›bet for planl‘gningskomponentlinjen.;
                           ENU=Specifies the total cost for this planning component line.];
                ApplicationArea=#Advanced;
                SourceExpr="Cost Amount";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position p† styklisten.;
                           ENU=Specifies the position of the component on the bill of material.];
                ApplicationArea=#Advanced;
                SourceExpr=Position;
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det andet referencenummer for komponentens position, f.eks. det alternative positionsnummer for en komponent p† en printplade.;
                           ENU=Specifies the second reference number for the component position, such as the alternate position number of a component on a circuit board.];
                ApplicationArea=#Advanced;
                SourceExpr="Position 2";
                Visible=FALSE }

    { 74  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tredje referencenummer for komponentens position p† en stykliste, f.eks. det alternative positionsnummer for en komponent p† en printplade.;
                           ENU=Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.];
                ApplicationArea=#Advanced;
                SourceExpr="Position 3";
                Visible=FALSE }

    { 72  ;2   ;Field     ;
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
    VAR
      ItemAvailFormsMgt@1000 : Codeunit 353;

    BEGIN
    END.
  }
}

