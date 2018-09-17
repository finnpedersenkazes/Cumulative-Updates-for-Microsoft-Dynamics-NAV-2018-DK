OBJECT Page 102 Item Journal Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Varekladdetyper;
               ENU=Item Journal Templates];
    SourceTable=Table82;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 17      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Type;
                                 ENU=Te&mplate];
                      Image=Template }
      { 18      ;2   ;Action    ;
                      CaptionML=[DAN=Navne;
                                 ENU=Batches];
                      ToolTipML=[DAN=Vis eller rediger flere sagskladder for en bestemt skabelon. Du kan bruge k›rsler, hvis du har brug for flere kladder af en bestemt type.;
                                 ENU=View or edit multiple journals for a specific template. You can use batches when you need multiple journals of a certain type.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 262;
                      RunPageLink=Journal Template Name=FIELD(Name);
                      Image=Description }
    }
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

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion der skal bruges sammen med denne varekladdetype.;
                           ENU=Specifies the type of transaction that will be used with this item journal template.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Type }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om varekladdetypen skal v‘re a gentagelseskladde.;
                           ENU=Specifies whether the item journal template will be a recurring journal.];
                ApplicationArea=#Suite;
                SourceExpr=Recurring }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. Series" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele bilagsnumre til finansposter, der bogf›res fra kladder ved hj‘lp af denne type.;
                           ENU=Specifies the number series code used to assign document numbers to ledger entries that are posted from journals using this template.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Posting No. Series" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Source Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Reason Code" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 21  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Advanced;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
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

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver journalrapport, der udskrives, n†r du klikker p† Bogf›r og udskriv.;
                           ENU=Specifies the posting report that is printed when you click Post and Print.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 31  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der udskrives, n†r du udskriver varekladden.;
                           ENU=Specifies the name of the report that is printed when you print the item journal.];
                ApplicationArea=#Advanced;
                SourceExpr="Posting Report Caption";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det id, der tildeles lagerjournalrapporten.;
                           ENU=Specifies the ID assigned to the Whse. Register Report.];
                ApplicationArea=#Advanced;
                SourceExpr="Whse. Register Report ID";
                Visible=FALSE }

    { 39  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der udskrives, n†r du udskriver varekladden.;
                           ENU=Specifies the name of the report that is printed when you print the item journal.];
                ApplicationArea=#Advanced;
                SourceExpr="Whse. Register Report Caption";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
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

