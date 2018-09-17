OBJECT Page 5188 Inter. Log Entry Comment List
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
    CaptionML=[DAN=Interak.logpost - bem.oversigt;
               ENU=Inter. Log Entry Comment List];
    LinksAllowed=No;
    SourceTable=Table5123;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Entry No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor kommentaren blev oprettet.;
                           ENU=Specifies the date on which the comment was created.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver selve kommentaren. Du kan bruge op til 80 tegn (b†de tal og bogstaver).;
                           ENU=Specifies the comment itself. You can enter a maximum of 80 characters, both numbers and letters.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Comment }

  }
  CODE
  {

    BEGIN
    END.
  }
}

