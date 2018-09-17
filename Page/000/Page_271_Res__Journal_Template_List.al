OBJECT Page 271 Res. Journal Template List
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
    CaptionML=[DAN=Ress.kladdetypeover.;
               ENU=Res. Journal Template List];
    SourceTable=Table206;
    PageType=List;
    RefreshOnActivate=Yes;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† kladden.;
                           ENU=Specifies the name of this journal.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af typen, s† du nemt kan identificere den.;
                           ENU=Specifies a description of the template for easy identification.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne kladde skal indeholde gentagelsesposter.;
                           ENU=Specifies if this journal will contain recurring entries.];
                ApplicationArea=#Jobs;
                SourceExpr=Recurring;
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Jobs;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontrolrapport, der udskrives, n†r du †bner fanen Handling, peger p† gruppen Bogf›ring og derefter klikker p† Kontroller.;
                           ENU=Specifies the test report that is printed when, on the Actions tab in the Posting group, you choose Test Report.];
                ApplicationArea=#Jobs;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den journalrapport, du vil have tilknyttet denne kladde.;
                           ENU=Specifies the posting report that you want associated with this journal.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en rapport udskrives automatisk ved bogf›ring.;
                           ENU=Specifies whether a report is printed automatically when you post.];
                ApplicationArea=#Jobs;
                SourceExpr="Force Posting Report";
                Visible=FALSE }

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

