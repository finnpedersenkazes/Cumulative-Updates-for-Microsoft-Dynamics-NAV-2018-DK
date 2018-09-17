OBJECT Page 930 Assembly Quote
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Montagetilbud;
               ENU=Assembly Quote];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table900;
    SourceTableView=SORTING(Document Type,No.)
                    ORDER(Ascending)
                    WHERE(Document Type=CONST(Quote));
    PageType=Document;
    OnOpenPage=BEGIN
                 IsUnitCostEditable := TRUE;
                 IsAsmToOrderEditable := TRUE;

                 UpdateWarningOnLines;
               END;

    OnAfterGetRecord=BEGIN
                       IsUnitCostEditable := NOT IsStandardCostItem;
                       IsAsmToOrderEditable := NOT IsAsmToOrder;
                     END;

    ActionList=ACTIONS
    {
      { 18      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 14      ;1   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=F† vist statistiske oplysninger om recorden, f.eks. v‘rdien af bogf›rte poster.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Assembly;
                      RunPageOnRec=Yes;
                      Image=Statistics;
                      OnAction=BEGIN
                                 ShowStatistics;
                               END;
                                }
      { 15      ;1   ;Action    ;
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
      { 31      ;1   ;Action    ;
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
      { 32      ;1   ;Action    ;
                      CaptionML=[DAN=Bem‘rkninger;
                                 ENU=Comments];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 907;
                      RunPageLink=Document Type=FIELD(Document Type),
                                  Document No.=FIELD(No.),
                                  Document Line No.=CONST(0);
                      Image=ViewComments }
      { 42      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      ActionContainerType=ActionItems;
                      Image=Action }
      { 19      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater kostpris;
                                 ENU=Update Unit Cost];
                      ToolTipML=[DAN=Opdater kostprisen for den overordnede vare i overensstemmelse med ‘ndringerne i montagestyklisten.;
                                 ENU=Update the cost of the parent item per changes to the assembly BOM.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=IsUnitCostEditable;
                      Image=UpdateUnitCost;
                      OnAction=BEGIN
                                 UpdateUnitCost;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      CaptionML=[DAN=Opdater linjer;
                                 ENU=Refresh Lines];
                      ToolTipML=[DAN=Opdater oplysningerne p† linjerne i overensstemmelse med ‘ndringerne i hovedet.;
                                 ENU=Update information on the lines according to changes that you made on the header.];
                      ApplicationArea=#Assembly;
                      Image=RefreshLines;
                      OnAction=BEGIN
                                 RefreshBOM;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Vis disponering;
                                 ENU=Show Availability];
                      ToolTipML=[DAN="Vis, hvor meget af montageordren, der kan monteres efter forfaldsdatoen baseret p† tilg‘ngeligheden af de kr‘vede komponenter. Dette vises i feltet Mulighed for montage. ";
                                 ENU="View how many of the assembly order quantity can be assembled by the due date based on availability of the required components. This is shown in the Able to Assemble field. "];
                      ApplicationArea=#Assembly;
                      Image=ItemAvailbyLoc;
                      OnAction=BEGIN
                                 ShowAvailability;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General];
                GroupType=Group }

    { 3   ;2   ;Field     ;
                AssistEdit=Yes;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Assembly;
                SourceExpr="No.";
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den vare, der er ved at blive monteret med montageordren.;
                           ENU=Specifies the number of the item that is being assembled with the assembly order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Item No.";
                TableRelation=Item.No. WHERE (Assembly BOM=CONST(Yes));
                Importance=Promoted;
                Editable=IsAsmToOrderEditable }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af montageelementet.;
                           ENU=Specifies the description of the assembly item.];
                ApplicationArea=#Assembly;
                SourceExpr=Description }

    { 33  ;2   ;Group     ;
                GroupType=Group }

    { 6   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange enheder af montageelementet, du forventer at montere med montageordren.;
                           ENU=Specifies how many units of the assembly item that you expect to assemble with the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr=Quantity;
                Importance=Promoted;
                Editable=IsAsmToOrderEditable }

    { 30  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan hver enhed af varen eller ressourcen m†les, f.eks. i enheder eller timer. Som standard inds‘ttes v‘rdien i feltet Basisenhed p† kortet vare eller ressource.;
                           ENU=Specifies how each unit of the item or resource is measured, such as in pieces or hours. By default, the value in the Base Unit of Measure field on the item or resource card is inserted.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit of Measure Code";
                Editable=IsAsmToOrderEditable }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren blev bogf›rt.;
                           ENU=Specifies the date on which the assembly order is posted.];
                ApplicationArea=#Assembly;
                SourceExpr="Posting Date";
                Importance=Promoted }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageelementet skal v‘re tilg‘ngeligt.;
                           ENU=Specifies the date when the assembled item is due to be available for use.];
                ApplicationArea=#Assembly;
                SourceExpr="Due Date";
                Importance=Promoted;
                Editable=IsAsmToOrderEditable }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at starte.;
                           ENU=Specifies the date when the assembly order is expected to start.];
                ApplicationArea=#Assembly;
                SourceExpr="Starting Date" }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor montageordren forventes at slutte.;
                           ENU=Specifies the date when the assembly order is expected to finish.];
                ApplicationArea=#Assembly;
                SourceExpr="Ending Date" }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om montageordren er knyttet til en salgsordre, som angiver, at elementet er monteret under en ordre.;
                           ENU=Specifies if the assembly order is linked to a sales order, which indicates that the item is assembled to order.];
                ApplicationArea=#Assembly;
                SourceExpr="Assemble to Order";
                OnDrillDown=BEGIN
                              ShowAsmToOrder;
                            END;
                             }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om bilaget er †bent, afventer godkendelse, er faktureret til forudbetaling eller er frigivet til n‘ste fase i behandlingen.;
                           ENU=Specifies if the document is open, waiting to be approved, invoiced for prepayment, or released to the next stage of processing.];
                ApplicationArea=#Assembly;
                SourceExpr=Status }

    { 34  ;1   ;Part      ;
                Name=Lines;
                CaptionML=[DAN=Linjer;
                           ENU=Lines];
                ApplicationArea=#Assembly;
                SubPageLink=Document Type=FIELD(Document Type),
                            Document No.=FIELD(No.);
                PagePartID=Page931;
                PartType=Page }

    { 23  ;1   ;Group     ;
                CaptionML=[DAN=Bogf›ring;
                           ENU=Posting];
                GroupType=Group }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver varens variant p† linjen.;
                           ENU=Specifies the variant of the item on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Variant Code";
                Importance=Promoted;
                Editable=IsAsmToOrderEditable }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den lokation, som du vil bogf›re afgangen af montageelementet for.;
                           ENU=Specifies the location to which you want to post output of the assembly item.];
                ApplicationArea=#Location;
                SourceExpr="Location Code";
                Importance=Promoted;
                Editable=IsAsmToOrderEditable }

    { 58  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den placering, som montageelementet er bogf›rt for, som afgang, Her hentes det til lager eller afsendes, hvis det monteres under en salgsordre.;
                           ENU=Specifies the bin the assembly item is posted to as output and from where it is taken to storage or shipped if it is assembled to a sales order.];
                ApplicationArea=#Warehouse;
                SourceExpr="Bin Code";
                Editable=IsAsmToOrderEditable }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver omkostningen, p† ‚n enhed af varen eller ressourcen p† linjen.;
                           ENU=Specifies the cost of one unit of the item or resource on the line.];
                ApplicationArea=#Assembly;
                SourceExpr="Unit Cost";
                Editable=IsUnitCostEditable }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den totale kostpris for montageordren.;
                           ENU=Specifies the total unit cost of the assembly order.];
                ApplicationArea=#Assembly;
                SourceExpr="Cost Amount";
                Editable=IsUnitCostEditable }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der er ansvarlig for bilaget.;
                           ENU=Specifies the ID of the user who is responsible for the document.];
                ApplicationArea=#Assembly;
                SourceExpr="Assigned User ID";
                Visible=False }

    { 7   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 11  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(Item No.);
                PagePartID=Page910;
                PartType=Page }

    { 44  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page911;
                ProviderID=34;
                PartType=Page }

    { 43  ;1   ;Part      ;
                ApplicationArea=#Assembly;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page912;
                ProviderID=34;
                PartType=Page }

    { 8   ;1   ;Part      ;
                ApplicationArea=#Assembly;
                PartType=System;
                SystemPartID=RecordLinks }

    { 9   ;1   ;Part      ;
                ApplicationArea=#Assembly;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      IsUnitCostEditable@1000 : Boolean INDATASET;
      IsAsmToOrderEditable@1001 : Boolean INDATASET;

    BEGIN
    END.
  }
}

