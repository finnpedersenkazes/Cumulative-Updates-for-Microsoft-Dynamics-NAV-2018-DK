OBJECT Page 7603 Customized Calendar Changes
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Tilpassede kalender‘ndringer;
               ENU=Customized Calendar Changes];
    SourceTable=Table7602;
    DataCaptionExpr=GetCaption;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kildetypen for posten, f.eks. Virksomhed.;
                           ENU=Specifies the source type, such as company, for this entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Type";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken basiskalender der blev brugt som basis for den tilpassede kalender.;
                           ENU=Specifies which base calendar was used as the basis for this customized calendar.];
                ApplicationArea=#Advanced;
                SourceExpr="Base Calendar Code";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Tilbagevendende;
                           ENU=Recurring System];
                ToolTipML=[DAN=Angiver en dato eller dag som en tilbagevendende fridag eller arbejdsdag.;
                           ENU=Specifies a date or day as a recurring nonworking or working day.];
                ApplicationArea=#Advanced;
                SourceExpr="Recurring System" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, der er tilknyttet den tilpassede kalenderpost.;
                           ENU=Specifies the date associated with this customized calendar entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Date }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den ugedag, som er tilknyttet posten.;
                           ENU=Specifies the day of the week associated with this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Day }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af posten.;
                           ENU=Specifies a description of this entry.];
                ApplicationArea=#Advanced;
                SourceExpr=Description }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Fridag;
                           ENU=Nonworking];
                ToolTipML=[DAN=Angiver, at dagen ikke er en arbejdsdag.;
                           ENU=Specifies that the day is not a working day.];
                ApplicationArea=#Advanced;
                SourceExpr=Nonworking }

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

