OBJECT Page 5870 BOM Structure
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Styklistestruktur;
               ENU=BOM Structure];
    InsertAllowed=No;
    DeleteAllowed=No;
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
      { 29      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 28      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Varedisponering pr.;
                                 ENU=&Item Availability by];
                      Image=ItemAvailability }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event];
                      ToolTipML=[DAN=Se, hvordan den faktiske og forventede tilg‘ngelige saldo for en vare udvikler sig over tid i henhold til udbud og eftersp›rgsel.;
                                 ENU=View how the actual and the projected available balance of an item will develop over time according to supply and demand events.];
                      ApplicationArea=#Advanced;
                      Image=Event;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByEvent);
                               END;
                                }
      { 26      ;2   ;Action    ;
                      CaptionML=[DAN=Periode;
                                 ENU=Period];
                      ToolTipML=[DAN=Vis det forventede antal af en vare over tid i henhold til tidsperioder som f.eks. dag, uge eller m†ned.;
                                 ENU=View the projected quantity of the item over time according to time periods, such as day, week, or month.];
                      ApplicationArea=#Advanced;
                      Image=Period;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByPeriod);
                               END;
                                }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Variant;
                                 ENU=Variant];
                      ToolTipML=[DAN=Vis eller rediger varens varianter. I stedet for at konfigurere hver varefarve som en separat vare kan du konfigurere de forskellige farver som varianter af varen.;
                                 ENU=View or edit the item's variants. Instead of setting up each color of an item as a separate item, you can set up the various colors as variants of the item.];
                      ApplicationArea=#Advanced;
                      Image=ItemVariant;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByVariant);
                               END;
                                }
      { 15      ;2   ;Action    ;
                      AccessByPermission=TableData 14=R;
                      CaptionML=[DAN=Lokation;
                                 ENU=Location];
                      ToolTipML=[DAN=Vis det faktiske og det forventede antal af en vare efter lokation.;
                                 ENU=View the actual and projected quantity of the item per location.];
                      ApplicationArea=#Advanced;
                      Image=Warehouse;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByLocation);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Styklisteniveau;
                                 ENU=BOM Level];
                      ToolTipML=[DAN=F† vist tilg‘ngelighedstallene for styklistevarer, der viser, hvor mange enheder af en overordnet vare, du kan fremstille, baseret p† tilg‘ngeligheden af underordnede varer.;
                                 ENU=View availability figures for items on bills of materials that show how many units of a parent item you can make based on the availability of child items.];
                      ApplicationArea=#Advanced;
                      Image=BOMLevel;
                      OnAction=BEGIN
                                 ItemAvail(ItemAvailFormsMgt.ByBOM);
                               END;
                                }
      { 5       ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;Action    ;
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
                ToolTipML=[DAN=Angiver de elementer, der vises i vinduet Styklistestruktur.;
                           ENU=Specifies the items that are shown in the BOM Structure window.];
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

    { 3   ;2   ;Field     ;
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

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens beskrivelse.;
                           ENU=Specifies the item's description.];
                ApplicationArea=#Assembly;
                SourceExpr=Description;
                Editable=FALSE;
                Style=Strong;
                StyleExpr=IsParentExpr }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Advarsel;
                           ENU=Warning];
                ToolTipML=[DAN=Angiver, om styklistelinjen har ops‘tnings- eller dataproblemer.;
                           ENU=Specifies if the BOM line has setup or data issues.];
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

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens niveau p† i styklistestrukturen.;
                           ENU=Specifies the item's level in the BOM structure.];
                ApplicationArea=#Advanced;
                SourceExpr="Low-Level Code";
                Visible=FALSE }

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
                SourceExpr="Qty. per Parent";
                Editable=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten, der kr‘ves for at samle eller producere ‚n enhed af topvaren.;
                           ENU=Specifies how many units of the component are required to assemble or produce one unit of the top item.];
                ApplicationArea=#Assembly;
                DecimalPlaces=0:5;
                SourceExpr="Qty. per Top Item";
                Visible=FALSE;
                Editable=FALSE }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code";
                Editable=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens genbestillingssystem.;
                           ENU=Specifies the item's replenishment system.];
                ApplicationArea=#Assembly;
                SourceExpr="Replenishment System";
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal dage, der kr‘ves for at samle eller producere varen.;
                           ENU=Specifies the total number of days that are required to assemble or produce the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead-Time Offset";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver enhver sikkerhedstid, der er defineret for varen.;
                           ENU=Specifies any safety lead time that is defined for the item.];
                ApplicationArea=#Advanced;
                SourceExpr="Safety Lead Time";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor lang tid det tager at genbestille varen ved k›b, montage eller produktion.;
                           ENU=Specifies how long it takes to replenish the item, by purchase, assembly, or production.];
                ApplicationArea=#Advanced;
                SourceExpr="Lead Time Calculation";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      Item@1004 : Record 27;
      AsmHeader@1009 : Record 900;
      ProdOrderLine@1002 : Record 5406;
      ItemAvailFormsMgt@1001 : Codeunit 353;
      IsParentExpr@1010 : Boolean INDATASET;
      ItemFilter@1008 : Code[250];
      ShowBy@1005 : 'Item,Assembly,Production';
      Text000@1012 : TextConst 'DAN=Der blev ikke fundet varer med styklisteniveauer.;ENU=Could not find items with BOM levels.';
      HasWarning@1011 : Boolean INDATASET;
      Text001@1003 : TextConst 'DAN=Der er ingen advarsler.;ENU=There are no warnings.';

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
    BEGIN
      Item.SETFILTER("No.",ItemFilter);
      Item.SETRANGE("Date Filter",0D,WORKDATE);
      CalcBOMTree.SetItemFilter(Item);
      CASE ShowBy OF
        ShowBy::Item:
          BEGIN
            Item.FINDFIRST;
            IF (NOT Item.HasBOM) AND (Item."Routing No." = '') THEN
              ERROR(Text000);
            CalcBOMTree.GenerateTreeForItems(Item,Rec,0);
          END;
        ShowBy::Production:
          CalcBOMTree.GenerateTreeForProdLine(ProdOrderLine,Rec,0);
        ShowBy::Assembly:
          CalcBOMTree.GenerateTreeForAsm(AsmHeader,Rec,0);
      END;

      CurrPage.UPDATE(FALSE);
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

    LOCAL PROCEDURE ItemAvail@32(AvailType@1000 : Option);
    VAR
      Item@1001 : Record 27;
    BEGIN
      TESTFIELD(Type,Type::Item);

      Item.GET("No.");
      Item.SETFILTER("No.","No.");
      Item.SETRANGE("Date Filter",0D,"Needed by Date");
      Item.SETFILTER("Variant Filter","Variant Code");
      IF ShowBy <> ShowBy::Item THEN
        Item.SETFILTER("Location Filter","Location Code");

      ItemAvailFormsMgt.ShowItemAvailFromItem(Item,AvailType);
    END;

    BEGIN
    END.
  }
}

