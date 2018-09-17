OBJECT Page 5872 BOM Cost Shares
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Styklistekostprisfordelinger;
               ENU=BOM Cost Shares];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table5870;
    PageType=Worksheet;
    SourceTableTemporary=Yes;
    OnOpenPage=BEGIN
                 RefreshPage;
               END;

    OnAfterGetRecord=VAR
                       DummyBOMWarningLog@1000 : Record 5874;
                     BEGIN
                       IsParentExpr := NOT "Is Leaf";

                       HasWarning := NOT IsLineOk(FALSE,DummyBOMWarningLog);
                     END;

    ActionList=ACTIONS
    {
      { 29      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 28      ;1   ;Action    ;
                      CaptionML=[DAN=Vis advarsler;
                                 ENU=Show Warnings];
                      ToolTipML=[DAN=F† vist oplysninger om flaskehalse.;
                                 ENU=View details about bottlenecks.];
                      ApplicationArea=#Advanced;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ErrorLog;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowWarningsForAllLines;
                               END;
                                }
      { 45      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 42      ;1   ;Action    ;
                      CaptionML=[DAN=Kostprisfordeling for stykliste;
                                 ENU=BOM Cost Share Distribution];
                      ToolTipML=[DAN=F† en grafisk oversigt over, hvordan en samlet eller fremstillet vares kostpris er fordelt via dens stykliste. Det f›rste diagram viser den samlede kostpris for den overordnede vares komponenter og arbejdskraftressourcer opdelt i op til fem forskellige omkostningsandele. Cirkeldiagrammet Efter materiale/arbejde viser den forholdsm‘ssige fordeling mellem den overordnede vares materiale- og arbejdsudgifter samt dens egne produktionsudgifter. Materialeudgiftsandelen omfatter varens materialeudgifter. Arbejdsudgiftsandelen omfatter kapacitet, kapacitets- og underleverand›rudgifter. Cirkeldiagrammet Efter direkte/indirekte viser den forholdsm‘ssige fordeling mellem den overordnede vares direkte og indirekte omkostninger. Den direkte omkostningsandel omfatter varens materiale-, kapacitets- og underleverand›rudgifter.;
                                 ENU=Get a graphical overview of how an assembled or produced item's cost is distributed through its BOM. The first chart shows the total unit cost of the parent item's components and labor resources broken down in up to five different cost shares. The pie chart labeled By Material/Labor shows the proportional distribution between the parent item's material and labor costs, as well as its own manufacturing overhead. The material cost share includes the item's material costs. The labor cost share includes capacity, capacity overhead and subcontracted costs. The pie chart labeled By Direct/Indirect shows the proportional distribution between the parent item's direct and indirect costs. The direct cost share includes the item's material, capacity, and subcontracted costs.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 ShowBOMCostShareDistribution;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 20  ;1   ;Group     ;
                CaptionML=[DAN=Indstilling;
                           ENU=Option];
                GroupType=GridLayout }

    { 19  ;2   ;Field     ;
                CaptionML=[DAN=Varefilter;
                           ENU=Item Filter];
                ToolTipML=[DAN=Angiver de varer, der vises i vinduet Styklistekostprisfordelinger.;
                           ENU=Specifies the items that are shown in the BOM Cost Shares window.];
                ApplicationArea=#Assembly;
                SourceExpr=ItemFilter;
                OnValidate=BEGIN
                             RefreshPage;
                           END;

                OnLookup=VAR
                           Item@1001 : Record 27;
                           ItemList@1000 : Page 31;
                         BEGIN
                           ItemList.SETTABLEVIEW(Item);
                           ItemList.LOOKUPMODE := TRUE;
                           IF ItemList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                             ItemList.GETRECORD(Item);
                             Text := Item."No.";
                             EXIT(TRUE);
                           END;
                           EXIT(FALSE);
                         END;
                          }

    { 2   ;1   ;Group     ;
                Name=Group;
                CaptionML=[DAN=Linjer;
                           ENU=Lines];
                IndentationColumnName=Indentation;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens position i styklistestrukturen. Underliggende varer indrykkes under deres overordnede varer.;
                           ENU=Specifies the item's position in the BOM structure. Lower-level items are indented under their parents.];
                ApplicationArea=#Assembly;
                SourceExpr=Type }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No.";
                Editable=FALSE;
                Style=Strong;
                StyleExpr=IsParentExpr }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens beskrivelse.;
                           ENU=Specifies the item's description.];
                ApplicationArea=#Assembly;
                SourceExpr=Description;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=IsParentExpr }

    { 30  ;2   ;Field     ;
                CaptionML=[DAN=Advarsel;
                           ENU=Warning];
                ToolTipML=[DAN=Angiver, om feltet kan v‘lges for at †bne vinduet Styklisteadvarselslog og f† vist en beskrivelse af problemet.;
                           ENU=Specifies if the field can be chosen to open the BOM Warning Log window to see a description of the issue.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr=HasWarning;
                Editable=FALSE;
                Style=Attention;
                StyleExpr=HasWarning;
                OnDrillDown=BEGIN
                              IF HasWarning THEN
                                ShowWarnings;
                            END;
                             }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den variantkode, du har indtastet i feltet Variantfilter i vinduet Varedisponering pr. styklisteniveau.;
                           ENU=Specifies the variant code that you entered in the Variant Filter field in the Item Availability by BOM Level window.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten, der kr‘ves for at samle eller producere ‚n enhed af den overordnede vare.;
                           ENU=Specifies how many units of the component are required to assemble or produce one unit of the parent.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr="Qty. per Parent" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten, der kr‘ves for at samle eller producere ‚n enhed af topvaren.;
                           ENU=Specifies how many units of the component are required to assemble or produce one unit of the top item.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr="Qty. per Top Item";
                Editable=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten, der kr‘ves for at samle eller producere ‚n enhed p† styklistelinjen.;
                           ENU=Specifies how many units of the component are required to assemble or produce one unit of the item on the BOM line.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Qty. per BOM Line";
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver enhedskoden for styklistevaren. ";
                           ENU="Specifies the unit of measure of the BOM item. "];
                ApplicationArea=#Assembly;
                SourceExpr="BOM Unit of Measure Code";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens genbestillingssystem.;
                           ENU=Specifies the item's replenishment system.];
                ApplicationArea=#Assembly;
                SourceExpr="Replenishment System";
                Editable=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                BlankZero=Yes;
                SourceExpr="Unit Cost";
                Visible=FALSE;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer g†r til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %";
                Visible=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, der g†r til spilde, for at fremstille antallet af topvarer.;
                           ENU=Specifies how many units of the item are scrapped to output the top item quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Qty. per Parent";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af varen, der g†r til spilde, for at fremstille antallet af overordnede varer.;
                           ENU=Specifies how many units of the item are scrapped to output the parent item quantity.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap Qty. per Top Item";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Advanced;
                BlankZero=Yes;
                SourceExpr="Indirect Cost %";
                Visible=FALSE;
                Editable=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens IPO-bidrag.;
                           ENU=Specifies the item's overhead rate.];
                ApplicationArea=#Manufacturing;
                BlankZero=Yes;
                SourceExpr="Overhead Rate";
                Visible=FALSE;
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens lotst›rrelse. V‘rdien kopieres fra feltet Lotst›rrelse p† varekortet.;
                           ENU=Specifies the item's lot size. The value is copied from the Lot Size field on the item card.];
                ApplicationArea=#Advanced;
                SourceExpr="Lot Size";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den produktionsstykliste, som varen repr‘senterer.;
                           ENU=Specifies the number of the production BOM that the item represents.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Production BOM No.";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† varens produktionsordrerute.;
                           ENU=Specifies the number of the item's production order routing.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing No.";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan kostprisen p† ressourcen p† montagestyklisten tildeles under montage.;
                           ENU=Specifies how the cost of the resource on the assembly BOM is allocated during assembly.];
                ApplicationArea=#Assembly;
                SourceExpr="Resource Usage Type";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede materialepris for alle elementer p† alle niveauer af den overordnede vares stykliste, som f›jes til materialeprisen for selve varen.;
                           ENU=Specifies the material cost of all items at all levels of the parent item's BOM, added to the material cost of the item itself.];
                ApplicationArea=#Assembly;
                SourceExpr="Rolled-up Material Cost" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de kapacitetsomkostninger, der vedr›rer varens overordnede vare og andre varer i den overordnede vares stykliste.;
                           ENU=Specifies the capacity costs related to the item's parent item and other items in the parent item's BOM.];
                ApplicationArea=#Assembly;
                SourceExpr="Rolled-up Capacity Cost" }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen p† enkeltniveau for udlicitering til en underleverand›r.;
                           ENU=Specifies the single-level cost of outsourcing operations to a subcontractor.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Subcontracted Cost" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens kapacitetsomkostninger akkumuleret fra underliggende vareniveauer.;
                           ENU=Specifies the item's overhead capacity cost rolled up from underlying item levels.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Mfg. Ovhd Cost" }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de akkumulerede faste omkostninger for varen.;
                           ENU=Specifies the rolled-up manufacturing overhead cost of the item.];
                ApplicationArea=#Assembly;
                SourceExpr="Rolled-up Capacity Ovhd. Cost" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for alle komponentmaterialer, der efterh†nden g†r til spilde for at producere den overordnede vare.;
                           ENU=Specifies the cost of all component material that will eventually be scrapped to produce the parent item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Scrap Cost" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede materialekostpris for alle komponenter p† den overordnede vares stykliste.;
                           ENU=Specifies the total material cost of all components on the parent item's BOM.];
                ApplicationArea=#Manufacturing;
                BlankZero=Yes;
                SourceExpr="Single-Level Material Cost";
                Visible=FALSE;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de kapacitetsomkostninger, der kun vedr›rer varens overordnede vare.;
                           ENU=Specifies the capacity costs related to the item's parent item only.];
                ApplicationArea=#Manufacturing;
                BlankZero=Yes;
                SourceExpr="Single-Level Capacity Cost";
                Visible=FALSE;
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen p† enkeltniveau for udlicitering til en underleverand›r.;
                           ENU=Specifies the single-level cost of outsourcing operations to a subcontractor.];
                ApplicationArea=#Manufacturing;
                BlankZero=Yes;
                SourceExpr="Single-Level Subcontrd. Cost";
                Visible=FALSE;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de faste kapacitetsomkostninger p† enkeltniveau.;
                           ENU=Specifies the single-level capacity overhead cost.];
                ApplicationArea=#Manufacturing;
                BlankZero=Yes;
                SourceExpr="Single-Level Cap. Ovhd Cost";
                Visible=FALSE;
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de faste produktionsomkostninger p† enkeltniveau.;
                           ENU=Specifies the single-level manufacturing overhead cost.];
                ApplicationArea=#Manufacturing;
                BlankZero=Yes;
                SourceExpr="Single-Level Mfg. Ovhd Cost";
                Visible=FALSE;
                Editable=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kostprisen for alle materialer p† styklisteniveauet, der efterh†nden g†r til spilde for at producere den overordnede vare.;
                           ENU=Specifies the cost of material at this BOM level that will eventually be scrapped in order to produce the parent item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Single-Level Scrap Cost";
                Visible=FALSE }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af alle omkostninger p† dette styklisteniveau.;
                           ENU=Specifies the sum of all cost at this BOM level.];
                ApplicationArea=#Assembly;
                SourceExpr="Total Cost" }

  }
  CODE
  {
    VAR
      Item@1004 : Record 27;
      AsmHeader@1009 : Record 900;
      ProdOrderLine@1002 : Record 5406;
      IsParentExpr@1010 : Boolean INDATASET;
      ItemFilter@1008 : Code[250];
      ShowBy@1005 : 'Item,Assembly,Production';
      Text000@1012 : TextConst 'DAN=Ingen af varerne i filteret har en stykliste.;ENU=None of the items in the filter have a BOM.';
      Text001@1001 : TextConst 'DAN=Der er ingen advarsler.;ENU=There are no warnings.';
      HasWarning@1003 : Boolean INDATASET;

    [External]
    PROCEDURE InitItem@1(VAR NewItem@1000 : Record 27);
    BEGIN
      Item.COPY(NewItem);
      ItemFilter := Item."No.";
      ShowBy := ShowBy::Item;
    END;

    [External]
    PROCEDURE InitAsmOrder@5(NewAsmHeader@1000 : Record 900);
    BEGIN
      AsmHeader := NewAsmHeader;
      ShowBy := ShowBy::Assembly;
    END;

    [External]
    PROCEDURE InitProdOrder@6(NewProdOrderLine@1000 : Record 5406);
    BEGIN
      ProdOrderLine := NewProdOrderLine;
      ShowBy := ShowBy::Production;
    END;

    LOCAL PROCEDURE RefreshPage@2();
    VAR
      CalcBOMTree@1000 : Codeunit 5870;
      HasBOM@1001 : Boolean;
    BEGIN
      Item.SETFILTER("No.",ItemFilter);
      Item.SETRANGE("Date Filter",0D,WORKDATE);
      CalcBOMTree.SetItemFilter(Item);

      CASE ShowBy OF
        ShowBy::Item:
          BEGIN
            Item.FINDSET;
            REPEAT
              HasBOM := Item.HasBOM OR (Item."Routing No." <> '')
            UNTIL HasBOM OR (Item.NEXT = 0);

            IF NOT HasBOM THEN
              ERROR(Text000);
            CalcBOMTree.GenerateTreeForItems(Item,Rec,2);
          END;
        ShowBy::Production:
          CalcBOMTree.GenerateTreeForProdLine(ProdOrderLine,Rec,2);
        ShowBy::Assembly:
          CalcBOMTree.GenerateTreeForAsm(AsmHeader,Rec,2);
      END;

      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE ShowBOMCostShareDistribution@8();
    VAR
      Item@1001 : Record 27;
    BEGIN
      TESTFIELD(Type,Type::Item);

      Item.GET("No.");
      Item.SETFILTER("No.","No.");
      Item.SETFILTER("Variant Filter","Variant Code");
      IF ShowBy <> ShowBy::Item THEN
        Item.SETFILTER("Location Filter","Location Code");

      REPORT.RUN(REPORT::"BOM Cost Share Distribution",TRUE,TRUE,Item);
    END;

    LOCAL PROCEDURE ShowWarnings@10();
    VAR
      TempBOMWarningLog@1001 : TEMPORARY Record 5874;
    BEGIN
      IF IsLineOk(TRUE,TempBOMWarningLog) THEN
        MESSAGE(Text001)
      ELSE
        PAGE.RUNMODAL(PAGE::"BOM Warning Log",TempBOMWarningLog);
    END;

    LOCAL PROCEDURE ShowWarningsForAllLines@27();
    VAR
      TempBOMWarningLog@1001 : TEMPORARY Record 5874;
    BEGIN
      IF AreAllLinesOk(TempBOMWarningLog) THEN
        MESSAGE(Text001)
      ELSE
        PAGE.RUNMODAL(PAGE::"BOM Warning Log",TempBOMWarningLog);
    END;

    BEGIN
    END.
  }
}

