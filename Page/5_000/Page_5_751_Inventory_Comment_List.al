OBJECT Page 5751 Inventory Comment List
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
    CaptionML=[DAN=Bem‘rkningslinjer;
               ENU=Comment List];
    LinksAllowed=No;
    SourceTable=Table5748;
    DataCaptionFields=Document Type,No.;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Advanced;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvorn†r bem‘rkningen blev oprettet.;
                           ENU=Specifies when the comment was created.];
                ApplicationArea=#Advanced;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den faktiske bem‘rkningstekst.;
                           ENU=Specifies the actual comment text.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

  }
  CODE
  {

    BEGIN
    END.
  }
}

