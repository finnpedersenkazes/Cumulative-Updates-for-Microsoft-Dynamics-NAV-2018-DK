OBJECT Page 7701 Miniform Subform
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Linjer;
               ENU=Lines];
    LinksAllowed=No;
    SourceTable=Table7701;
    PageType=ListPart;
    AutoSplitKey=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver debitors eller kreditors omr†de med henblik p† rapportering til INTRASTAT.;
                           ENU=Specifies the area of the customer or vendor, for the purpose of reporting to INTRASTAT.];
                ApplicationArea=#Advanced;
                SourceExpr=Area }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen af data, der er defineret p† miniformularlinjen.;
                           ENU=Specifies the type of data that is defined in the miniform line.];
                ApplicationArea=#Advanced;
                SourceExpr="Field Type" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tabel i programmet, som dataene stammer fra, eller der skal indtastes data i.;
                           ENU=Specifies the number of the table in the program from which the data comes or in which it is entered.];
                ApplicationArea=#Advanced;
                SourceExpr="Table No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† det felt, hvor dataene kommer fra, eller der skal indtastes data i.;
                           ENU=Specifies the number of the field from which the data comes or in which the data is entered.];
                ApplicationArea=#Advanced;
                SourceExpr="Field No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den maksimale l‘ngde p† feltv‘rdien. ";
                           ENU="Specifies the maximum length of the field value. "];
                ApplicationArea=#Advanced;
                SourceExpr="Field Length" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver tekst, hvis felttypen er Tekst.;
                           ENU=Specifies text if the field type is Text.];
                ApplicationArea=#Advanced;
                SourceExpr=Text }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken miniformular der hentes, n†r brugeren foretager et valg p† linjen p† det h†ndholdte udstyr.;
                           ENU=Specifies which miniform will be called when the user on the handheld selects the choice on the line.];
                ApplicationArea=#Advanced;
                SourceExpr="Call Miniform" }

  }
  CODE
  {

    BEGIN
    END.
  }
}

