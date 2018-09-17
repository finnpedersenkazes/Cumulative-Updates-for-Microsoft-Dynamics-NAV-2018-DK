OBJECT Page 6314 PBI Sales Pipeline
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
    CaptionML=[DAN=PBI-salgspipeline;
               ENU=PBI Sales Pipeline];
    SourceTable=Table6305;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 PBISalesPipelineChartCalc@1000 : Codeunit 6309;
               BEGIN
                 PBISalesPipelineChartCalc.GetValues(Rec);
               END;

  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Id;
                           ENU=ID];
                ToolTipML=[DAN=Angiver id'et.;
                           ENU=Specifies the ID.];
                ApplicationArea=#All;
                SourceExpr=ID }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Fase;
                           ENU=Stage];
                ToolTipML=[DAN=Angiver den fase, som salgspipelinen er i.;
                           ENU=Specifies the stage of the sales pipeline that this entry is at.];
                ApplicationArea=#All;
                SourceExpr="Row No." }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=V‘rdi;
                           ENU=Value];
                ToolTipML=[DAN=Angiver v‘rdien.;
                           ENU=Specifies the value.];
                ApplicationArea=#All;
                SourceExpr=Value }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Navn p† m†l;
                           ENU=Measure Name];
                ToolTipML=[DAN=Angiver navnet.;
                           ENU=Specifies the name.];
                ApplicationArea=#All;
                SourceExpr="Measure Name" }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Salgsproceskode;
                           ENU=Sales Cycle Code];
                ToolTipML=[DAN=Angiver en kode for salgsprocessen.;
                           ENU=Specifies a code for the sales process.];
                ApplicationArea=#All;
                SourceExpr="Measure No." }

  }
  CODE
  {

    BEGIN
    END.
  }
}

