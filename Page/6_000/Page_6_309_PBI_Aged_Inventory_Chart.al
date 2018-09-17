OBJECT Page 6309 PBI Aged Inventory Chart
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
    CaptionML=[DAN=PBI-aldersfordelt lagerbeholdningsdiagram;
               ENU=PBI Aged Inventory Chart];
    SourceTable=Table6305;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 PBIAgedInventoryCalc@1008 : Codeunit 6307;
               BEGIN
                 PBIAgedInventoryCalc.GetValues(Rec);
               END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Id;
                           ENU=ID];
                ToolTipML=[DAN=Angiver id'et.;
                           ENU=Specifies the ID.];
                ApplicationArea=#All;
                SourceExpr=ID }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=V‘rdi;
                           ENU=Value];
                ToolTipML=[DAN=Angiver v‘rdien.;
                           ENU=Specifies the value.];
                ApplicationArea=#All;
                SourceExpr=Value }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Dato;
                           ENU=Date];
                ToolTipML=[DAN=Angiver datoen.;
                           ENU=Specifies the date.];
                ApplicationArea=#All;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Periodetype;
                           ENU=Period Type];
                ToolTipML=[DAN=Angiver sorteringen.;
                           ENU=Specifies the sorting.];
                ApplicationArea=#All;
                SourceExpr="Period Type" }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Periodetypesortering;
                           ENU=Period Type Sorting];
                ToolTipML=[DAN=Angiver sorteringen.;
                           ENU=Specifies the sorting.];
                ApplicationArea=#All;
                SourceExpr="Period Type Sorting" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

