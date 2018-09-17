OBJECT Page 6308 PBI Aged Acc. Receivable
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
    CaptionML=[DAN=PBI-aldersfordelte tilgodehavender;
               ENU=PBI Aged Acc. Receivable];
    SourceTable=Table6305;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 PBIAgedAccCalc@1000 : Codeunit 6306;
                 ChartManagement@1001 : Codeunit 1315;
               BEGIN
                 PBIAgedAccCalc.GetValues(Rec,CODEUNIT::"Aged Acc. Receivable",ChartManagement.AgedAccReceivableName);
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
                ToolTipML=[DAN=Angiver datoen.;
                           ENU=Specifies the date.];
                ApplicationArea=#All;
                SourceExpr="Period Type" }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Dato;
                           ENU=Date];
                ToolTipML=[DAN=Angiver sorteringen.;
                           ENU=Specifies the sorting.];
                ApplicationArea=#All;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Navn p† m†l;
                           ENU=Measure Name];
                ToolTipML=[DAN=Angiver sorteringen.;
                           ENU=Specifies the sorting.];
                ApplicationArea=#All;
                SourceExpr="Measure Name" }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Datosortering;
                           ENU=Date Sorting];
                ToolTipML=[DAN=Angiver sorteringen.;
                           ENU=Specifies the sorting.];
                ApplicationArea=#All;
                SourceExpr="Date Sorting" }

    { 9   ;2   ;Field     ;
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

