OBJECT Page 931 Assembly Quote Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    SourceTable=Table901;
    DelayedInsert=Yes;
    PopulateAllFields=Yes;
    PageType=ListPart;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 27      ;    ;ActionContainer;
                      CaptionML=[DAN=Linje;
                                 ENU=Line];
                      ActionContainerType=ActionItems }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      ActionContainerType=NewDocumentItems;
                      Image=Line }
      { 25      ;2   ;ActionGroup;
                      CaptionML=[DAN=Varedisponering pr.;
                                 ENU=Item Availability by];
                      ActionContainerType=NewDocumentItems;
                      Image=ItemAvailability }
      { 39      ;3   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Assembly;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 28      ;3   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Assembly;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 32      ;3   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Assembly;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 29      ;3   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Location;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 36      ;3   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Assembly;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvailFormsMgt.ShowItemAvailFromAsmLine(Rec,ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Vis advarsel;
                                 ENU=Show Warning];
                      ToolTipML=[DAN=F† vist oplysninger om tilg‘ngelighedsproblemer.;
                                 ENU=View details about availability issues.];
                      ApplicationArea=#Assembly;
                      Image=ShowWarning;
                      OnAction=BEGIN
                                 ShowAvailabilityWarning;
                               END;
                                }
      { 23      ;2   ;Action    ;
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
      { 31      ;2   ;Action    ;
                      Name=Item Tracking Lines;
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
      { 21      ;2   ;Action    ;
                      CaptionML=[DAN=Bem‘rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  Document No.=FIELD(Document No.),
                                  Document Line No.=FIELD(Line No.);
                      Image=ViewComments }
      { 16      ;2   ;Action    ;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=F† vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der kr‘ves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      Image=AssemblyBOM;
                      OnAction=BEGIN
                                 ShowAssemblyList;
                               END;
                                }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      ActionContainerType=NewDocumentItems;
                      Image=Action }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=V‘lg erstatningsvare;
                                 ENU=Select Item Substitution];
                      ToolTipML=[DAN=V‘lg en anden vare, der er konfigureret til at blive handlet i stedet for den originale vare, hvis den ikke er tilg‘ngelig.;
                                 ENU=Select another item that has been set up to be traded instead of the original item if it is unavailable.];
                      ApplicationArea=#Assembly;
                      Image=SelectItemSubstitution;
                      OnAction=BEGIN
                                 ShowItemSub;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=Udfold stykliste;
                                 ENU=Explode BOM];
                      ToolTipML=[DAN=Inds‘t nye linjer for komponenterne p† styklisten, f.eks. for at s‘lge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun repr‘senteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilf›je en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Assembly;
                      Image=ExplodeBOM;
                      OnAction=BEGIN
                                 ExplodeAssemblyList;
                                 CurrPage.UPDATE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 33  ;2   ;Field     ;
                DrillDown=Yes;
                ToolTipML=[DAN=Angiver Ja, hvis montagekomponenten ikke er tilg‘ngelig i den m‘ngde og med den forfaldsdato, der er angivet for montageordrelinjen.;
                           ENU=Specifies Yes if the assembly component is not available in the quantity and on the due date of the assembly order line.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Avail. Warning";
                OnDrillDown=BEGIN
                              ShowAvailabilityWarning;
                            END;
                             }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om montageordrelinjen er af typen Vare eller Ressource.;
                           ENU=Specifies if the assembly order line is of type Item or Resource.];
                ApplicationArea=#Assembly;
                SourceExpr=Type }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af montagekomponenten.;
                           ENU=Specifies the description of the assembly component.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den anden beskrivelse af montagekomponenten.;
                           ENU=Specifies the second description of the assembly component.];
                ApplicationArea=#Assembly;
                SourceExpr="Description 2";
                Visible=False }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogf›re forbruget af montagekomponenten for.;
                           ENU=Specifies the location from which you want to post consumption of the assembly component.];
                ApplicationArea=#Location;
                SourceExpr="Location Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code" }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten, der kr‘ves for at samle et montageelement.;
                           ENU=Specifies how many units of the assembly component are required to assemble one assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Quantity per" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montagekomponenten der forventes at blive forbrugt.;
                           ENU=Specifies how many units of the assembly component are expected to be consumed.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montagekomponenten skal v‘re tilg‘ngelig for forbrug if›lge montageordren.;
                           ENU=Specifies the date when the assembly component must be available for consumption by the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date";
                Visible=False }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den genneml›bstid, der er defineret for montagekomponenten p† montagestyklisten.;
                           ENU=Specifies the lead-time offset that is defined for the assembly component on the assembly BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Lead-Time Offset";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 1, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 1 Code";
                Visible=false }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for Genvejsdimension 2, der er en af de to globale dimensionskoder, du konfigurerer i vinduet Ops‘tning af Finans.;
                           ENU=Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.];
                ApplicationArea=#Suite;
                SourceExpr="Shortcut Dimension 2 Code";
                Visible=False }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den placering, hvor montagekomponenter skal placeres f›r montage, og hvorfra de bogf›res som forbrugte.;
                           ENU=Specifies the code of the bin where assembly components must be placed prior to assembly and from where they are posted as consumed.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Visible=False }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver links mellem forretningstransaktioner, som er lavet til varen, og en lagerkonto i finansposterne for at samle bel›bene for denne varetype i en gruppe.;
                           ENU=Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.];
                ApplicationArea=#Assembly;
                SourceExpr="Inventory Posting Group";
                Visible=False }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost" }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for montageordrelinjen.;
                           ENU=Specifies the cost of the assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Cost Amount" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antal pr. enhed for komponentvaren p† montageordrelinjen.;
                           ENU=Specifies the quantity per unit of measure of the component item on the assembly order line.];
                ApplicationArea=#Assembly;
                SourceExpr="Qty. per Unit of Measure" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kostprisen p† ressourcen p† montageordrelinjen tildeles montageelementet.;
                           ENU=Specifies how the cost of the resource on the assembly order line is allocated to the assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr="Resource Usage Type" }

  }
  CODE
  {
    VAR
      ItemAvailFormsMgt@1000 : Codeunit 353;

    BEGIN
    END.
  }
}

