OBJECT Page 5630 FA Journal Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Anl‘gskladdetyper;
               ENU=FA Journal Templates];
    SourceTable=Table5619;
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
                      ApplicationArea=#FixedAssets;
                      RunObject=Page 5633;
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
                ToolTipML=[DAN=Angiver navnet p† den kladdetype, du er ved at oprette.;
                           ENU=Specifies the name of the journal template you are creating.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kladdetype, du vil oprette.;
                           ENU=Specifies the journal template you are creating.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Description }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#FixedAssets;
                SourceExpr="No. Series" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den nummerserie, der bruges til at tildele bilagsnumre til finansposter, der er bogf›rt fra kladder.;
                           ENU=Specifies the code for the number series used to assign document numbers to ledger entries posted from journals.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting No. Series" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kladdetypen skal v‘re a gentagelseskladde.;
                           ENU=Specifies whether the journal template will be a recurring journal.];
                ApplicationArea=#FixedAssets;
                SourceExpr=Recurring }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Source Code";
                OnValidate=BEGIN
                             SourceCodeOnAfterValidate;
                           END;
                            }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Reason Code" }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 23  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 17  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rapport, der udskrives, hvis du v‘lger at udskrive en kontrolrapport fra en kladdek›rsel.;
                           ENU=Specifies the report that will be printed if you choose to print a test report from a journal batch.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 25  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der er angivet i feltet Kontrolrapport-id.;
                           ENU=Specifies the name of the report that is specified in the Test Report ID field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Test Report Caption";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den rapport, der udskrives, n†r du klikker p† Bogf›r og udskriv fra en kladde.;
                           ENU=Specifies the report that is printed when you click Post and Print from a journal batch.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 27  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der er angivet i feltet Journalrapport-id.;
                           ENU=Specifies the name of the report that is specified in the Posting Report ID field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Posting Report Caption";
                Visible=FALSE }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver den rapport, der udskrives, n†r du bogf›rer en kladdelinje, hvor feltet Anl‘gsbogf›ringstype = Reparation, ved at klikke p† Bogf›r og udskriv.";
                           ENU="Specifies the report that is printed when you post a journal line, where the FA Posting Type field = Maintenance, by clicking Post and Print."];
                ApplicationArea=#FixedAssets;
                SourceExpr="Maint. Posting Report ID";
                Visible=FALSE }

    { 37  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der er angivet i feltet Reparationsjournalrapport-id.;
                           ENU=Specifies the name of the report that is specified in the Maint. Posting Report ID field.];
                ApplicationArea=#FixedAssets;
                SourceExpr="Maint. Posting Report Caption";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en rapport udskrives automatisk ved bogf›ring.;
                           ENU=Specifies whether a report is printed automatically when you post.];
                ApplicationArea=#FixedAssets;
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

    LOCAL PROCEDURE SourceCodeOnAfterValidate@19004618();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

