OBJECT Page 125 Comment List
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
    SourceTable=Table97;
    DataCaptionFields=No.;
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
                ToolTipML=[DAN=Angiver den dato, som kommentaren blev oprettet p†.;
                           ENU=Specifies the date the comment was created.];
                ApplicationArea=#Advanced;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver selve bem‘rkningen.;
                           ENU=Specifies the comment itself.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kode for kommentaren.;
                           ENU=Specifies a code for the comment.];
                ApplicationArea=#Advanced;
                SourceExpr=Code;
                Visible=FALSE }

  }
  CODE
  {

    BEGIN
    END.
  }
}

