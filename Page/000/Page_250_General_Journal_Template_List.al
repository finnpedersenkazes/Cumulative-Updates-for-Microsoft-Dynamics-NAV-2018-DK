OBJECT Page 250 General Journal Template List
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
    CaptionML=[DAN=Finanskld.typeover.;
               ENU=General Journal Template List];
    SourceTable=Table80;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kladdetype, du er ved at oprette.;
                           ENU=Specifies the name of the journal template you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af den kladdetype, du er ved at oprette.;
                           ENU=Specifies a brief description of the journal template you are creating.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kladdetypen.;
                           ENU=Specifies the journal type.];
                ApplicationArea=#Advanced;
                SourceExpr=Type;
                Visible=FALSE }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kladdetypen skal v‘re a gentagelseskladde.;
                           ENU=Specifies whether the journal template will be a recurring journal.];
                ApplicationArea=#Advanced;
                SourceExpr=Recurring;
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Advanced;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Advanced;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om transaktioner, der er bogf›rt i finanskladden, skal afstemmes efter dokumentnummer og -type.;
                           ENU=Specifies whether transactions that are posted in the general journal must balance by document number and document type.];
                ApplicationArea=#Advanced;
                SourceExpr="Force Doc. Balance";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 27  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontrolrapport, der udskrives, n†r du klikker p† Kontroller.;
                           ENU=Specifies the test report that is printed when you click Test Report.];
                ApplicationArea=#Advanced;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 29  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den kontrolrapport, der udskrives, n†r du udskriver en kladde under denne kladdetype.;
                           ENU=Specifies the name of the test report that is printed when you print a journal under this journal template.];
                ApplicationArea=#Advanced;
                SourceExpr="Test Report Caption";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver journalrapport, der udskrives, n†r du v‘lger Bogf›r og udskriv.;
                           ENU=Specifies the posting report that is printed when you choose Post and Print.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 31  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der udskrives, n†r du udskriver kladden.;
                           ENU=Specifies the name of the report that is printed when you print the journal.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report Caption";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
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

