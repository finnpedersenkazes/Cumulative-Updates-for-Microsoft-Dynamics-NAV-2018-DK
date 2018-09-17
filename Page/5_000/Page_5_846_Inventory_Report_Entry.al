OBJECT Page 5846 Inventory Report Entry
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerrapportpost;
               ENU=Inventory Report Entry];
    SourceTable=Table5846;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om lagerrapportposten henviser til en vare eller en finanskonto.;
                           ENU=Specifies whether the inventory report entry refers to an item or a general ledger account.];
                ApplicationArea=#Advanced;
                SourceExpr=Type }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 54  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerrapportpostens type.;
                           ENU=Specifies a value that depends on the type of the inventory report entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Inventory;
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownInventory(Rec);
                            END;
                             }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Inventory (Interim)";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownInventoryInterim(Rec);
                            END;
                             }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="WIP Inventory";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownWIPInventory(Rec);
                            END;
                             }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Cost Applied Actual";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownDirectCostApplActual(Rec);
                            END;
                             }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Applied Actual";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownOverheadAppliedActual(Rec);
                            END;
                             }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Purchase Variance";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownPurchaseVariance(Rec);
                            END;
                             }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Inventory Adjmt.";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownInventoryAdjmt(Rec);
                            END;
                             }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Invt. Accrual (Interim)";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownInvtAccrualInterim(Rec);
                            END;
                             }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr=COGS;
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownCOGS(Rec);
                            END;
                             }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="COGS (Interim)";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownCOGSInterim(Rec);
                            END;
                             }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Material Variance";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownMaterialVariance(Rec);
                            END;
                             }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Capacity Variance";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownCapVariance(Rec);
                            END;
                             }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Subcontracted Variance";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownSubcontractedVariance(Rec);
                            END;
                             }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Capacity Overhead Variance";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownCapOverheadVariance(Rec);
                            END;
                             }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Mfg. Overhead Variance";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownMfgOverheadVariance(Rec);
                            END;
                             }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Cost Applied WIP";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownDirectCostApplToWIP(Rec);
                            END;
                             }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Applied WIP";
                OnLookup=BEGIN
                           GetInvtReport.DrillDownOverheadAppliedToWIP(Rec);
                         END;
                          }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Inventory To WIP";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownInvtToWIP(Rec);
                            END;
                             }

    { 48  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="WIP To Interim";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownWIPToInvtInterim(Rec);
                            END;
                             }

    { 50  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Direct Cost Applied";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownDirectCostApplied(Rec);
                            END;
                             }

    { 52  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en v�rdi, der afh�nger af lagerperiodepostens type.;
                           ENU=Specifies a value that depends on the type of the inventory period entry.];
                ApplicationArea=#Manufacturing;
                SourceExpr="Overhead Applied";
                OnDrillDown=BEGIN
                              GetInvtReport.DrillDownOverheadApplied(Rec);
                            END;
                             }

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
      GetInvtReport@1000 : Codeunit 5845;

    BEGIN
    END.
  }
}

