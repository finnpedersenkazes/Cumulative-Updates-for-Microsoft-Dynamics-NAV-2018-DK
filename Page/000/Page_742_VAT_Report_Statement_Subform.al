OBJECT Page 742 VAT Report Statement Subform
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
    CaptionML=[DAN=Underform til momsangivelsesrapport;
               ENU=VAT Report Statement Subform];
    SourceTable=Table742;
    PageType=ListPart;
    ShowFilter=No;
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et nummer, som identificerer linjen.;
                           ENU=Specifies a number that identifies the line.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Row No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af momsangivelsesrapporten.;
                           ENU=Specifies a description of the VAT report statement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kasse, som momsangivelsen g‘lder for.;
                           ENU=Specifies the number on the box that the VAT statement applies to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Box No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det bel›b, som momsbel›bet i Bel›b er beregnet ud fra.;
                           ENU=Specifies the amount that the VAT amount in the Amount is calculated from.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Base;
                Visible=FALSE }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver bel›bet for posten i angivelsesrapporten.;
                           ENU=Specifies the amount of the entry in the report statement.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Amount }

  }
  CODE
  {

    [External]
    PROCEDURE SelectFirst@1();
    BEGIN
      IF COUNT > 0 THEN
        FINDFIRST;
    END;

    BEGIN
    END.
  }
}

