OBJECT Page 5829 Inventory Period Entries
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerperiodeposter;
               ENU=Inventory Period Entries];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5815;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver typen for en lagerperiodepost, s�som lukket eller gen�bnet.;
                           ENU=Specifies the type for an inventory period entry, such as closed or re-opened.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Entry Type";
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den slutdato, som entydigt identificerer en lagerperiode.;
                           ENU=Specifies the ending date that uniquely identifies an inventory period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ending Date";
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor lagerperioden blev oprettet.;
                           ENU=Specifies the date when the inventory period entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creation Date";
                Editable=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tid, hvor lagerperioden blev oprettet.;
                           ENU=Specifies the time when the inventory period entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Creation Time";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den sidste varejournal i en lukket lagerperiode.;
                           ENU=Specifies the number of the last item register in a closed inventory period.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Closing Item Register No.";
                Editable=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� posten, som tildeles fra den angivne nummerserie, da posten blev oprettet.;
                           ENU=Specifies the number of the entry, as assigned from the specified number series when the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Entry No.";
                Visible=FALSE;
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver eventuelle nyttige oplysninger om lagerperiodeposten.;
                           ENU=Specifies any useful information about the inventory period entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {

    BEGIN
    END.
  }
}

