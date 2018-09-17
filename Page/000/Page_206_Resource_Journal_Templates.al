OBJECT Page 206 Resource Journal Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Ressourcekladdetyper;
               ENU=Resource Journal Templates];
    SourceTable=Table206;
    PageType=List;
    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Type;
                                 ENU=Te&mplate];
                      Image=Template }
      { 30      ;2   ;Action    ;
                      CaptionML=[DAN=Navne;
                                 ENU=Batches];
                      ToolTipML=[DAN=Vis eller rediger flere sagskladder for en bestemt skabelon. Du kan bruge k›rsler, hvis du har brug for flere kladder af en bestemt type.;
                                 ENU=View or edit multiple journals for a specific template. You can use batches when you need multiple journals of a certain type.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 272;
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
                ToolTipML=[DAN=Angiver navnet p† kladden.;
                           ENU=Specifies the name of this journal.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af typen, s† du nemt kan identificere den.;
                           ENU=Specifies a description of the template for easy identification.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om denne kladde skal indeholde gentagelsesposter.;
                           ENU=Specifies if this journal will contain recurring entries.];
                ApplicationArea=#Jobs;
                SourceExpr=Recurring }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Jobs;
                SourceExpr="No. Series" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele bilagsnumre til finansposter, der bogf›res fra kladder ved hj‘lp af denne type.;
                           ENU=Specifies the number series code used to assign document numbers to ledger entries that are posted from journals using this template.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting No. Series" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Source Code" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Reason Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Jobs;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 23  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Jobs;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontrolrapport, der udskrives, n†r du †bner fanen Handling, peger p† gruppen Bogf›ring og derefter klikker p† Kontroller.;
                           ENU=Specifies the test report that is printed when, on the Actions tab in the Posting group, you choose Test Report.];
                ApplicationArea=#Jobs;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 25  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den kontrolrapport, du har valgt i feltet Kontrolrapport-id.;
                           ENU=Specifies the name of the test report that you selected in the Test Report ID field.];
                ApplicationArea=#Jobs;
                SourceExpr="Test Report Caption";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den journalrapport, du vil have tilknyttet denne kladde.;
                           ENU=Specifies the posting report that you want associated with this journal.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 27  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den journalrapport, du har valgt i feltet Journalrapport-id.;
                           ENU=Specifies the name of the posting report you selected in the Posting Report ID field.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Report Caption";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
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

