OBJECT Page 36 Assembly BOM
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Montagestykliste;
               ENU=Assembly BOM];
    SourceTable=Table90;
    DataCaptionFields=Parent Item No.;
    PageType=List;
    AutoSplitKey=Yes;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Vare,Stykliste;
                                ENU=New,Process,Report,Item,BOM];
    OnAfterGetRecord=BEGIN
                       IsEmptyOrItem := Type IN [Type::" ",Type::Item];
                     END;

    OnInsertRecord=BEGIN
                     IsEmptyOrItem := Type IN [Type::" ",Type::Item];
                   END;

    OnAfterGetCurrRecord=BEGIN
                           IsEmptyOrItem := Type IN [Type::" ",Type::Item];
                         END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 20      ;1   ;Action    ;
                      Name=Show BOM;
                      CaptionML=[DAN=Vis stykliste;
                                 ENU=Show BOM];
                      ToolTipML=[DAN=F† vist styklistestrukturen.;
                                 ENU=View the BOM structure.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Hierarchy;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                                 BOMStructure@1000 : Page 5870;
                               BEGIN
                                 Item.GET("Parent Item No.");
                                 BOMStructure.InitItem(Item);
                                 BOMStructure.RUN;
                               END;
                                }
      { 19      ;1   ;Action    ;
                      CaptionML=[DAN=U&dfold stykliste;
                                 ENU=E&xplode BOM];
                      ToolTipML=[DAN=Inds‘t nye linjer for komponenterne p† styklisten, f.eks. for at s‘lge den overordnede vare som en pakke. ADVARSEL! Linjen for den overordnede vare bliver slettet og kun repr‘senteret af en beskrivelse. Hvis du vil fortryde, skal du slette komponentlinjerne og tilf›je en linje igen for den overordnede vare.;
                                 ENU=Insert new lines for the components on the bill of materials, for example to sell the parent item as a kit. CAUTION: The line for the parent item will be deleted and represented by a description only. To undo, you must delete the component lines and add a line the parent item again.];
                      ApplicationArea=#Assembly;
                      RunObject=Codeunit 51;
                      Promoted=Yes;
                      Enabled="Assembly BOM";
                      Image=ExplodeBOM;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes }
      { 5       ;1   ;Action    ;
                      Name=CalcStandardCost;
                      CaptionML=[DAN=Beregn kostpris;
                                 ENU=Calc. Standard Cost];
                      ToolTipML=[DAN=Opdater standardkostprisen p† varen ud fra de beregnede omkostninger for de underliggende komponenter.;
                                 ENU=Update the standard cost of the item based on the calculated costs of its underlying components.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      Image=CalculateCost;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CalcStdCost@1000 : Codeunit 5812;
                               BEGIN
                                 CalcStdCost.CalcItem("Parent Item No.",TRUE)
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Name=CalcUnitPrice;
                      CaptionML=[DAN=Beregn enhedspris;
                                 ENU=Calc. Unit Price];
                      ToolTipML=[DAN=Beregn enhedsprisen ud fra kostprisen og avanceprocenten.;
                                 ENU=Calculate the unit price based on the unit cost and the profit percentage.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=SuggestItemPrice;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 CalcStdCost@1000 : Codeunit 5812;
                               BEGIN
                                 CalcStdCost.CalcAssemblyItemPrice("Parent Item No.")
                               END;
                                }
      { 7       ;1   ;Action    ;
                      Name=Cost Shares;
                      CaptionML=[DAN=Kostprisfordelinger;
                                 ENU=Cost Shares];
                      ToolTipML=[DAN=F† vist, hvordan omkostningerne til underliggende varer p† styklisten akkumuleres til den overordnede vare. Oplysningerne arrangeres if›lge styklistens struktur for at afspejle de niveauer, som de enkelte omkostninger ang†r. Hvert vareniveau kan skjules eller vises for at f† et overblik eller en detaljeret visning.;
                                 ENU=View how the costs of underlying items in the BOM roll up to the parent item. The information is organized according to the BOM structure to reflect at which levels the individual costs apply. Each item level can be collapsed or expanded to obtain an overview or detailed view.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=CostBudget;
                      PromotedCategory=Category5;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                                 BOMCostShares@1000 : Page 5872;
                               BEGIN
                                 Item.GET("Parent Item No.");
                                 BOMCostShares.InitItem(Item);
                                 BOMCostShares.RUN;
                               END;
                                }
      { 21      ;1   ;Action    ;
                      CaptionML=[DAN=Indg†r-i;
                                 ENU=Where-Used];
                      ToolTipML=[DAN=F† vist en liste over styklister, hvor varen anvendes.;
                                 ENU=View a list of BOMs in which the item is used.];
                      ApplicationArea=#Assembly;
                      RunObject=Page 37;
                      RunPageView=SORTING(Type,No.);
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Track;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes }
      { 23      ;1   ;Action    ;
                      Name=View;
                      CaptionML=[DAN=Vis;
                                 ENU=View];
                      ToolTipML=[DAN=F† vist og rediger den valgte komponent.;
                                 ENU=View and modify the selected component.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=Item;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 Item@1000 : Record 27;
                                 Resource@1001 : Record 156;
                               BEGIN
                                 IF Type = Type::Item THEN BEGIN
                                   Item.GET("No.");
                                   PAGE.RUN(PAGE::"Item Card",Item)
                                 END ELSE
                                   IF Type = Type::Resource THEN BEGIN
                                     Resource.GET("No.");
                                     PAGE.RUN(PAGE::"Resource Card",Resource);
                                   END
                               END;
                                }
      { 25      ;1   ;Action    ;
                      Name=AssemblyBOM;
                      CaptionML=[DAN=Montagestykliste;
                                 ENU=Assembly BOM];
                      ToolTipML=[DAN=F† vist eller rediger den stykliste, der angiver, hvilke varer og ressourcer der kr‘ves for at samle montageelementet.;
                                 ENU=View or edit the bill of material that specifies which items and resources are required to assemble the assembly item.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Visible=FALSE;
                      Enabled=FALSE;
                      Image=BOM;
                      PromotedCategory=Category4;
                      PromotedOnly=Yes;
                      RunPageMode=View;
                      OnAction=VAR
                                 BOMComponent@1000 : Record 90;
                               BEGIN
                                 IF NOT "Assembly BOM" THEN
                                   EXIT;

                                 COMMIT;
                                 BOMComponent.SETRANGE("Parent Item No.","No.");
                                 PAGE.RUN(PAGE::"Assembly BOM",BOMComponent);
                                 CurrPage.UPDATE;
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
                ToolTipML=[DAN=Angiver, om montagestyklistekomponenten er en vare eller en ressource.;
                           ENU=Specifies if the assembly BOM component is an item or a resource.];
                ApplicationArea=#Assembly;
                SourceExpr=Type;
                OnValidate=BEGIN
                             IsEmptyOrItem := Type IN [Type::" ",Type::Item];
                           END;
                            }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No." }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af montagestyklistekomponenten.;
                           ENU=Specifies a description of the assembly BOM component.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om montagestyklistekomponenten er en montagestykliste.;
                           ENU=Specifies if the assembly BOM component is an assembly BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly BOM" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten der kr‘ves for at producere eller montere den overordnede vare.;
                           ENU=Specifies how many units of the component are required to produce or assemble the parent item.];
                ApplicationArea=#Assembly;
                SourceExpr="Quantity per" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken serviceartikel komponenten p† linjen bruges i.;
                           ENU=Specifies which service item the component on the line is used in.];
                ApplicationArea=#Advanced;
                SourceExpr="Installed in Item No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position p† styklisten.;
                           ENU=Specifies the position of the component on the bill of material.];
                ApplicationArea=#Assembly;
                SourceExpr=Position }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position i montagestyklistestrukturen.;
                           ENU=Specifies the component's position in the assembly BOM structure.];
                ApplicationArea=#Assembly;
                SourceExpr="Position 2";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tredje referencenummer for komponentens position p† en stykliste, f.eks. det alternative positionsnummer for en komponent p† en printplade.;
                           ENU=Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.];
                ApplicationArea=#Advanced;
                SourceExpr="Position 3";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en maskine, der skal bruges ved behandling af komponenten p† denne linje i montagestyklisten.;
                           ENU=Specifies a machine that should be used when processing the component on this line of the assembly BOM.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Machine No.";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal dage, der kr‘ves for at montere varen p† montagestyklistelinjen.;
                           ENU=Specifies the total number of days required to assemble the item on the assembly BOM line.];
                ApplicationArea=#Assembly;
                SourceExpr="Lead-Time Offset";
                Visible=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kostprisen p† ressourcen p† montagestyklisten tildeles under montage.;
                           ENU=Specifies how the cost of the resource on the assembly BOM is allocated during assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Resource Usage Type";
                Visible=FALSE;
                Editable=NOT IsEmptyOrItem;
                HideValue=IsEmptyOrItem }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 18  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(Parent Item No.);
                PagePartID=Page910;
                PartType=Page }

    { 17  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 11  ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

    { 13  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page911;
                Visible=Type = Type::Item;
                PartType=Page }

    { 9   ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page912;
                Visible=Type = Type::Resource;
                PartType=Page }

  }
  CODE
  {
    VAR
      IsEmptyOrItem@1000 : Boolean INDATASET;

    BEGIN
    END.
  }
}

