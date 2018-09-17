OBJECT Page 7321 Whse. Journal Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Lagerkladdetyper;
               ENU=Whse. Journal Templates];
    SourceTable=Table7309;
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
                      ApplicationArea=#Warehouse;
                      RunObject=Page 7323;
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
                ToolTipML=[DAN=Angiver navnet p† lagerkladdetypen.;
                           ENU=Specifies the name of the warehouse journal template.];
                ApplicationArea=#Warehouse;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af lagerkladdetypen.;
                           ENU=Specifies a description of the warehouse journal template.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken type transaktion lagerkladdetypen skal bruges til.;
                           ENU=Specifies the type of transaction the warehouse journal template is being used for.];
                ApplicationArea=#Warehouse;
                SourceExpr=Type }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Warehouse;
                SourceExpr="No. Series" }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerseriekode, der bruges til at tildele bilagsnumre til de lagerposter, der er registreret fra kladden.;
                           ENU=Specifies the number series code used to assign document numbers to the warehouse entries that are registered from this journal.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering No. Series" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Code" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Warehouse;
                SourceExpr="Reason Code" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Warehouse;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 21  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Warehouse;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrolrapport, der udskrives, n†r du klikker p† Registrering og derefter Kontroller.;
                           ENU=Specifies the number of the test report that is printed when you click Registering, Test Report.];
                ApplicationArea=#Warehouse;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 25  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den kontrolrapport, der udskrives, n†r du klikker p† Registrering og derefter Kontroller.;
                           ENU=Specifies the name of the test report that is printed when you click Registering, Test Report.];
                ApplicationArea=#Warehouse;
                SourceExpr="Test Report Caption";
                Visible=FALSE }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den registreringsrapport, der udskrives, n†r du klikker p† Registrering, Registrer og derefter p† Udskriv.;
                           ENU=Specifies the number of the registering report that is printed when you click Registering, Register and Print.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 31  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den rapport, der udskrives, n†r du klikker p† Registrering, Registrer og derefter p† Udskriv.;
                           ENU=Specifies the name of the report that is printed when you click Registering, Register and Print.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering Report Caption";
                Visible=FALSE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der automatisk skal udskrives en registreringsrapport, n†r du registrerer poster fra kladden.;
                           ENU=Specifies that a registering report is printed automatically when you register entries from the journal.];
                ApplicationArea=#Warehouse;
                SourceExpr="Force Registering Report";
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

