OBJECT Page 5118 Rlshp. Mgt. Comment List
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
    CaptionML=[DAN=Rel.styringsbem�rkn.oversigt;
               ENU=Rlshp. Mgt. Comment List];
    LinksAllowed=No;
    SourceTable=Table5061;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� fasen i salgsprocessen.;
                           ENU=Specifies the number of the stage within the sales cycle.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Sub No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, som kommentaren blev oprettet p�.;
                           ENU=Specifies the date the comment was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver selve bem�rkningen.;
                           ENU=Specifies the comment itself.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Comment }

  }
  CODE
  {

    BEGIN
    END.
  }
}

