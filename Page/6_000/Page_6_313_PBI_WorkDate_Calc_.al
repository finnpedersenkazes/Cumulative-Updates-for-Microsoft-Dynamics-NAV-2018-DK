OBJECT Page 6313 PBI WorkDate Calc.
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=PBI-arbejdsdatoberegn.;
               ENU=PBI WorkDate Calc.];
    SourceTable=Table2000000026;
    SourceTableView=WHERE(Number=CONST(1));
    PageType=List;
    OnAfterGetRecord=VAR
                       LogInManagement@1000 : Codeunit 40;
                     BEGIN
                       WorkDateNAV := LogInManagement.GetDefaultWorkDate;
                     END;

  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 3   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                CaptionML=[DAN=Arbejdsdato;
                           ENU=Work Date];
                ToolTipML=[DAN=Angiver den dato, der er angivet som arbejdsdatoen. Dette er enten i dag eller en anden dato.;
                           ENU=Specifies the date that is set as the work date. This is either today or another date.];
                ApplicationArea=#All;
                SourceExpr=WorkDateNAV }

  }
  CODE
  {
    VAR
      WorkDateNAV@1002 : Date;

    BEGIN
    END.
  }
}

