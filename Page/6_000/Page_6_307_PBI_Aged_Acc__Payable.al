OBJECT Page 6307 PBI Aged Acc. Payable
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
    CaptionML=[DAN=PBI-aldersfordelt g‘ld;
               ENU=PBI Aged Acc. Payable];
    SourceTable=Table6305;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 PBIAgedAccCalc@1000 : Codeunit 6306;
                 ChartManagement@1001 : Codeunit 1315;
               BEGIN
                 PBIAgedAccCalc.GetValues(Rec,CODEUNIT::"Aged Acc. Payable",ChartManagement.AgedAccPayableName);
               END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 8   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Id;
                           ENU=ID];
                ToolTipML=[DAN=Angiver id'et.;
                           ENU=Specifies the ID.];
                ApplicationArea=#All;
                SourceExpr=ID }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=V‘rdi;
                           ENU=Value];
                ToolTipML=[DAN=Angiver v‘rdien.;
                           ENU=Specifies the value.];
                ApplicationArea=#All;
                SourceExpr=Value }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Periodetype;
                           ENU=Period Type];
                ToolTipML=[DAN=Angiver typen.;
                           ENU=Specifies the type.];
                ApplicationArea=#All;
                SourceExpr="Period Type" }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Dato;
                           ENU=Date];
                ToolTipML=[DAN=Angiver datoen.;
                           ENU=Specifies the date.];
                ApplicationArea=#All;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Datosortering;
                           ENU=Date Sorting];
                ToolTipML=[DAN=Angiver sorteringen.;
                           ENU=Specifies the sorting.];
                ApplicationArea=#All;
                SourceExpr="Date Sorting" }

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

