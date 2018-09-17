OBJECT Page 99000789 Production BOM Version Lines
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
    MultipleNewLines=Yes;
    LinksAllowed=No;
    SourceTable=Table99000772;
    DataCaptionFields=Production BOM No.;
    PageType=ListPart;
    AutoSplitKey=Yes;
    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 1907988304;1 ;ActionGroup;
                      CaptionML=[DAN=Ko&mponent;
                                 ENU=&Component];
                      Image=Components }
      { 1901991904;2 ;Action    ;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Manufacturing;
                      Image=ViewComments;
                      OnAction=BEGIN
                                 ShowComment;
                               END;
                                }
      { 1901313404;2 ;Action    ;
                      CaptionML=[DAN=Indg†r-i;
                                 ENU=Where-Used];
                      ToolTipML=[DAN=F† vist en liste over styklister, hvor varen anvendes.;
                                 ENU=View a list of BOMs in which the item is used.];
                      ApplicationArea=#Manufacturing;
                      Image=Where-Used;
                      OnAction=BEGIN
                                 ShowWhereUsed;
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
                ToolTipML=[DAN=Angiver typen for produktionsstyklistelinjen.;
                           ENU=Specifies the type of production BOM line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Type }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Manufacturing;
                SourceExpr="No." }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af produktionsstyklistelinjen.;
                           ENU=Specifies a description of the production BOM line.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Description }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan feltet Antal bliver beregnet.;
                           ENU=Specifies how to calculate the Quantity field.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Calculation Formula";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver l‘ngden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the length of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Length;
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bredden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the width of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Width;
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dybden af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the depth of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Depth;
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver v‘gten af en vareenhed, n†r den m†les i den angivne enhed.;
                           ENU=Specifies the weight of one item unit when measured in the specified unit of measure.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Weight;
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af komponenten der kr‘ves for at producere den overordnede vare.;
                           ENU=Specifies how many units of the component are required to produce the parent item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Quantity per" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Unit of Measure Code" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den procentdel af varen, du forventer g†r til spilde i produktionsprocessen.;
                           ENU=Specifies the percentage of the item that you expect to be scrapped in the production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Scrap %" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rutebindingskoden.;
                           ENU=Specifies the routing link code.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Routing Link Code" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver komponentens position p† styklisten.;
                           ENU=Specifies the position of the component on the bill of material.];
                ApplicationArea=#Manufacturing;
                SourceExpr=Position;
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver mere pr‘cist, om komponenten skal vises p† en bestemt position i styklisten for at repr‘sentere en bestemt produktionsproces.;
                           ENU=Specifies more exactly whether the component is to appear at a certain position in the BOM to represent a certain production process.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Position 2";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tredje referencenummer for komponentens position p† en stykliste, f.eks. det alternative positionsnummer for en komponent p† en printplade.;
                           ENU=Specifies the third reference number for the component position on a bill of material, such as the alternate position number of a component on a print card.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Position 3";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal dage, der kr‘ves for at fremstille varen.;
                           ENU=Specifies the total number of days required to produce this item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Lead-Time Offset";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvorfra produktionsstyklisten er gyldig.;
                           ENU=Specifies the date from which this production BOM is valid.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Starting Date";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvorfra produktionsstyklisten ikke l‘ngere er gyldig.;
                           ENU=Specifies the date from which this production BOM is no longer valid.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Ending Date";
                Visible=FALSE }

  }
  CODE
  {

    LOCAL PROCEDURE ShowComment@1();
    VAR
      ProdOrderCompComment@1000 : Record 99000776;
    BEGIN
      ProdOrderCompComment.SETRANGE("Production BOM No.","Production BOM No.");
      ProdOrderCompComment.SETRANGE("BOM Line No.","Line No.");
      ProdOrderCompComment.SETRANGE("Version Code","Version Code");

      PAGE.RUN(PAGE::"Prod. Order BOM Cmt. Sheet",ProdOrderCompComment);
    END;

    LOCAL PROCEDURE ShowWhereUsed@2();
    VAR
      Item@1000 : Record 27;
      ProdBOMHeader@1001 : Record 99000771;
      ProdBOMVersion@1002 : Record 99000779;
      ProdBOMWhereUsed@1003 : Page 99000811;
    BEGIN
      IF Type = Type::" " THEN
        EXIT;

      ProdBOMVersion.GET("Production BOM No.","Version Code");
      CASE Type OF
        Type::Item:
          BEGIN
            Item.GET("No.");
            ProdBOMWhereUsed.SetItem(Item,ProdBOMVersion."Starting Date");
          END;
        Type::"Production BOM":
          BEGIN
            ProdBOMHeader.GET("No.");
            ProdBOMWhereUsed.SetProdBOM(ProdBOMHeader,ProdBOMVersion."Starting Date");
          END;
      END;
      ProdBOMWhereUsed.RUN;
    END;

    BEGIN
    END.
  }
}

