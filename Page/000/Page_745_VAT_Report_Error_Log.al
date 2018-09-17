OBJECT Page 745 VAT Report Error Log
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
    CaptionML=[DAN=Momsrapportfejllog;
               ENU=VAT Report Error Log];
    SourceTable=Table745;
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
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver fejlmeddelelsen, der er resultatet af validering af en momsrapport.;
                           ENU=Specifies the error message that is the result of validating a VAT report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Error Message" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

