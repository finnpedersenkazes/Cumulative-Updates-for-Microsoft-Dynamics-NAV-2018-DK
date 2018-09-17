OBJECT Page 858 Cash Flow Comment List
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
    CaptionML=[DAN=Pengestr›msbem‘rkningslinjer;
               ENU=Cash Flow Comment List];
    SourceTable=Table842;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1000;1   ;Group     ;
                GroupType=Repeater }

    { 1001;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No." }

    { 1003;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen for pengestr›mskommentaren.;
                           ENU=Specifies the date of the cash flow comment.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Date }

    { 1005;2   ;Field     ;
                ToolTipML=[DAN=Angiver bem‘rkningen for recorden.;
                           ENU=Specifies the comment for the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Comment }

    { 1007;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for recorden.;
                           ENU=Specifies the code of the record.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Code;
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

