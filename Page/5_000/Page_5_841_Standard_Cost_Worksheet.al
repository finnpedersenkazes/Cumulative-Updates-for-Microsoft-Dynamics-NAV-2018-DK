OBJECT Page 5841 Standard Cost Worksheet
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Standardkostpriskladde;
               ENU=Standard Cost Worksheet];
    SaveValues=Yes;
    SourceTable=Table5841;
    DelayedInsert=Yes;
    DataCaptionFields=Standard Cost Worksheet Name;
    PageType=Worksheet;
    OnOpenPage=BEGIN
                 IF "Standard Cost Worksheet Name" <> '' THEN // called from batch
                   CurrWkshName := "Standard Cost Worksheet Name";

                 IF NOT StdCostWkshName.GET(CurrWkshName) THEN
                   IF NOT StdCostWkshName.FINDFIRST THEN BEGIN
                     StdCostWkshName.Name := DefaultNameTxt;
                     StdCostWkshName.Description := DefaultNameTxt;
                     StdCostWkshName.INSERT;
                   END;
                 CurrWkshName := StdCostWkshName.Name;

                 FILTERGROUP := 2;
                 SETRANGE("Standard Cost Worksheet Name",CurrWkshName);
                 FILTERGROUP := 0;
               END;

    OnNewRecord=BEGIN
                  StdCostWkshName.GET("Standard Cost Worksheet Name");
                  Type := xRec.Type;
                  "Replenishment System" := "Replenishment System"::Assembly;
                END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 76      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 77      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Foresl† kostpris (standard);
                                 ENU=Suggest I&tem Standard Cost];
                      ToolTipML=[DAN=Opretter forslag til ‘ndring af kostprisfordelinger af standardomkostninger p† varekort. Bem‘rk, at de foresl†ede ‘ndringer ikke er implementeret.;
                                 ENU=Creates suggestions for changing the cost shares of standard costs on Item cards. Note that the suggested changes are not implemented.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=SuggestItemCost;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Item@1001 : Record 27;
                                 SuggItemStdCost@1002 : Report 5851;
                               BEGIN
                                 Item.SETRANGE("Replenishment System",Item."Replenishment System"::Purchase);
                                 SuggItemStdCost.SETTABLEVIEW(Item);
                                 SuggItemStdCost.SetCopyToWksh(CurrWkshName);
                                 SuggItemStdCost.RUNMODAL;
                               END;
                                }
      { 78      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Foresl† &kapacitetskostpris (standard);
                                 ENU=Suggest &Capacity Standard Cost];
                      ToolTipML=[DAN=Opret forslag p† nye kladdelinjer til ‘ndring af kostpriserne og kostprisfordelingerne for standardkostpriser p† arbejdscenter, produktionsressource eller ressourcekort.;
                                 ENU=Create suggestions on new worksheet lines for changing the costs and cost shares of standard costs on work center, machine center, or resource cards.];
                      ApplicationArea=#Manufacturing;
                      Promoted=Yes;
                      Image=SuggestCapacity;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 SuggWorkMachCtrStdWksh@1002 : Report 5852;
                               BEGIN
                                 SuggWorkMachCtrStdWksh.SetCopyToWksh(CurrWkshName);
                                 SuggWorkMachCtrStdWksh.RUNMODAL;
                               END;
                                }
      { 81      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier standardkostpriskladde;
                                 ENU=Copy Standard Cost Worksheet];
                      ToolTipML=[DAN=Kopierer Standardkostpriskladder fra forskellige kilder til vinduet Standardkostpriskladde.;
                                 ENU=Copies standard cost worksheets from several sources into the Standard Cost Worksheet window.];
                      ApplicationArea=#Basic,#Suite;
                      Image=CopyWorksheet;
                      OnAction=VAR
                                 CopyStdCostWksh@1002 : Report 5853;
                               BEGIN
                                 CopyStdCostWksh.SetCopyToWksh(CurrWkshName);
                                 CopyStdCostWksh.RUNMODAL;
                               END;
                                }
      { 83      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Akkum. standardkostpris;
                                 ENU=Roll Up Standard Cost];
                      ToolTipML=[DAN=Akkumuler standardkostpriserne for montageelementer og fremstillede varer, f.eks. med ‘ndringer i standardkostprisen for komponenter og ‘ndringer i standardkostprisen for produktionskapacitet og montageressourcer. N†r du bruger funktionen, f›res alle ‘ndringer i standardkostpriserne i kladden ind i de tilknyttede produktions- eller montagestyklister, og omkostningerne anvendes p† alle styklisteniveauer.;
                                 ENU=Roll up the standard costs of assembled and manufactured items, for example, with changes in the standard cost of components and changes in the standard cost of production capacity and assembly resources. When you run the function, all changes to the standard costs in the worksheet are introduced in the associated production or assembly BOMs, and the costs are applied at each BOM level.];
                      ApplicationArea=#Assembly;
                      Promoted=Yes;
                      Image=RollUpCosts;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Item@1002 : Record 27;
                                 RollUpStdCost@1000 : Report 5854;
                               BEGIN
                                 CLEAR(RollUpStdCost);
                                 Item.SETRANGE("Costing Method",Item."Costing Method"::Standard);
                                 RollUpStdCost.SETTABLEVIEW(Item);
                                 RollUpStdCost.SetStdCostWksh(CurrWkshName);
                                 RollUpStdCost.RUNMODAL;
                               END;
                                }
      { 84      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Implementer std.kostpris‘ndringer;
                                 ENU=&Implement Standard Cost Changes];
                      ToolTipML=[DAN=Opdaterer ‘ndringerne i standardkostprisen i tabellen Vare med ‘ndringerne i tabellen Standardkostpriskladde.;
                                 ENU=Updates the changes in the standard cost in the Item table with the ones in the Standard Cost Worksheet table.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ImplementCostChanges;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 ImplStdCostChg@1001 : Report 5855;
                               BEGIN
                                 CLEAR(ImplStdCostChg);
                                 ImplStdCostChg.SetStdCostWksh(CurrWkshName);
                                 ImplStdCostChg.RUNMODAL;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 65  ;1   ;Field     ;
                Lookup=Yes;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† standardkostpriskladden.;
                           ENU=Specifies the name of the Standard Cost Worksheet.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=CurrWkshName;
                OnValidate=BEGIN
                             CurrWkshNameOnAfterValidate;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           COMMIT;
                           IF PAGE.RUNMODAL(0,StdCostWkshName) = ACTION::LookupOK THEN BEGIN
                             CurrWkshName := StdCostWkshName.Name;
                             FILTERGROUP := 2;
                             SETRANGE("Standard Cost Worksheet Name",CurrWkshName);
                             FILTERGROUP := 0;
                             IF FIND('-') THEN;
                           END;
                           CurrPage.UPDATE(FALSE);
                         END;
                          }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 61  ;2   ;Field     ;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver typen p† kladdelinjen.;
                           ENU=Specifies the type of worksheet line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 62  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af kladdelinjen.;
                           ENU=Specifies the description of the worksheet line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kostpris, der anvendes som et overslag, hvor afvigelser kan justeres p† et senere tidspunkt. Dette anvendes typisk ved montage og produktion, hvor omkostningerne varierer.;
                           ENU=Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Standard Cost" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Standard Cost" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver procentdelen af varens sidste k›bspris, der omfatter indirekte omkostninger, s†som fragt, der er knyttet til k›bet af varen.;
                           ENU=Specifies the percentage of the item's last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Indirect Cost %" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Indirect Cost %" }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver IPO-bidraget.;
                           ENU=Specifies the overhead rate.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Overhead Rate" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="New Overhead Rate" }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at du har udf›rt k›rslen Implementer std.kostpris‘ndringer.;
                           ENU=Specifies that you have run the Implement Standard Cost Changes batch job.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Implemented }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver genbestillingsmetoden for varerne, f.eks. k›bsordre eller produktionsordre.;
                           ENU=Specifies the replenishment method for the items, for example, purchase or prod. order.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Replenishment System" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver materialekostprisen p† enkeltniveau for varen.;
                           ENU=Specifies the single-level material cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Single-Lvl Material Cost";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Single-Lvl Material Cost";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kapacitetskostprisen p† enkeltniveau for varen.;
                           ENU=Specifies the single-level capacity cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Single-Lvl Cap. Cost";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Single-Lvl Cap. Cost";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver underleverand›rkostprisen p† enkeltniveau for varen.;
                           ENU=Specifies the single-level subcontracted cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Single-Lvl Subcontrd Cost";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Single-Lvl Subcontrd Cost";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den de faste kapacitetsomkostninger p† enkeltniveau for varen.;
                           ENU=Specifies the single-level capacity overhead cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Single-Lvl Cap. Ovhd Cost";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Single-Lvl Cap. Ovhd Cost";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den faste produktionsomkostninger p† enkeltniveau for varen.;
                           ENU=Specifies the single-level manufacturing overhead cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Single-Lvl Mfg. Ovhd Cost";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Single-Lvl Mfg. Ovhd Cost";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den akkumulerede materialekostpris for varen.;
                           ENU=Specifies the rolled-up material cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Material Cost";
                Visible=FALSE }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede akkumulerede materialekostpris baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated rolled-up material cost based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Rolled-up Material Cost";
                Visible=FALSE }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den akkumulerede kapacitetskostpris for varen.;
                           ENU=Specifies the rolled-up capacity cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Cap. Cost";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Rolled-up Cap. Cost";
                Visible=FALSE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den akkumulerede underleverand›rkostpris for varen.;
                           ENU=Specifies the rolled-up subcontracted cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Subcontrd Cost";
                Visible=FALSE }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Rolled-up Subcontrd Cost";
                Visible=FALSE }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de akkumulerede faste omkostninger for varen.;
                           ENU=Specifies the rolled-up capacity overhead cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Cap. Ovhd Cost";
                Visible=FALSE }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Rolled-up Cap. Ovhd Cost";
                Visible=FALSE }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de akkumulerede faste omkostninger for varen.;
                           ENU=Specifies the rolled-up manufacturing overhead cost of the item.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Rolled-up Mfg. Ovhd Cost";
                Visible=FALSE }

    { 56  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den opdaterede v‘rdi baseret p† k›rslen eller det, du har indtastet manuelt.;
                           ENU=Specifies the updated value based on either the batch job or what you have entered manually.];
                ApplicationArea=#Manufacturing;
                SourceExpr="New Rolled-up Mfg. Ovhd Cost";
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
      StdCostWkshName@1002 : Record 5840;
      CurrWkshName@1000 : Code[10];
      DefaultNameTxt@1004 : TextConst 'DAN=Standard;ENU=Default';

    LOCAL PROCEDURE CurrWkshNameOnAfterValidate@19031315();
    BEGIN
      CurrPage.SAVERECORD;
      COMMIT;
      FILTERGROUP := 2;
      SETRANGE("Standard Cost Worksheet Name",CurrWkshName);
      FILTERGROUP := 0;
      IF FIND('-') THEN;
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

