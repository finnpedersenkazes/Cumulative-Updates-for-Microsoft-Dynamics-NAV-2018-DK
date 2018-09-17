OBJECT Page 261 Item Journal Template List
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
    CaptionML=[DAN=Varekladdetypeover.;
               ENU=Item Journal Template List];
    SourceTable=Table82;
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
                ToolTipML=[DAN=Angiver navnet p† den varekladde, du er ved at oprette.;
                           ENU=Specifies the name of the item journal you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af den varekladdetype, du er ved at oprette.;
                           ENU=Specifies a brief description of the item journal template you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varekladdetypen skal v‘re a gentagelseskladde.;
                           ENU=Specifies whether the item journal template will be a recurring journal.];
                ApplicationArea=#Advanced;
                SourceExpr=Recurring;
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 8   ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontrolrapport, der udskrives, n†r du klikker p† Handling, peger p† Bogf›ring og derefter klikke p† Kontrolrapport.;
                           ENU=Specifies the test report that is printed when you click Actions, point to Posting, and then click Test Report.];
                ApplicationArea=#Advanced;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 25  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den kontrolrapport, der udskrives, n†r du udskriver varekladden.;
                           ENU=Specifies the name of the test report that is printed when you print the item journal.];
                ApplicationArea=#Advanced;
                SourceExpr="Test Report Caption";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver journalrapport, der udskrives, n†r du klikker p† Bogf›r og udskriv.;
                           ENU=Specifies the posting report that is printed when you click Post and Print.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 27  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der udskrives, n†r du udskriver varekladden.;
                           ENU=Specifies the name of the report that is printed when you print the item journal.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report Caption";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en rapport udskrives automatisk ved bogf›ring.;
                           ENU=Specifies whether a report is printed automatically when you post.];
                ApplicationArea=#Advanced;
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

