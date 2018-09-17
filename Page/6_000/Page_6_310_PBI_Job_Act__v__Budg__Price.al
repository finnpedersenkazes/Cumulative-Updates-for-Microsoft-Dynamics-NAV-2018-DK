OBJECT Page 6310 PBI Job Act. v. Budg. Price
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
    CaptionML=[DAN=PBI-sagshandling. v. budgetpris;
               ENU=PBI Job Act. v. Budg. Price];
    SourceTable=Table6305;
    PageType=List;
    SourceTableTemporary=Yes;
    OnOpenPage=VAR
                 PBIJobChartCalc@1002 : Codeunit 6308;
                 JobChartType@1003 : 'Profitability,Actual to Budget Cost,Actual to Budget Price';
               BEGIN
                 PBIJobChartCalc.GetValues(Rec,JobChartType::"Actual to Budget Price");
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
                CaptionML=[DAN=Sagsnr.;
                           ENU=Job No.];
                ToolTipML=[DAN=Angiver sagen.;
                           ENU=Specifies the job.];
                ApplicationArea=#All;
                SourceExpr="Measure No." }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Navn p� m�l;
                           ENU=Measure Name];
                ToolTipML=[DAN=Angiver navnet.;
                           ENU=Specifies the name.];
                ApplicationArea=#All;
                SourceExpr="Measure Name" }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=V�rdi;
                           ENU=Value];
                ToolTipML=[DAN=Angiver v�rdien.;
                           ENU=Specifies the value.];
                ApplicationArea=#All;
                SourceExpr=Value }

  }
  CODE
  {

    BEGIN
    END.
  }
}

