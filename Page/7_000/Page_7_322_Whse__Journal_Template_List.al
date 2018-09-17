OBJECT Page 7322 Whse. Journal Template List
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
    CaptionML=[DAN=Lagerkladdetypeoversigt;
               ENU=Whse. Journal Template List];
    SourceTable=Table7309;
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
                ToolTipML=[DAN=Angiver navnet p† lagerkladdetypen.;
                           ENU=Specifies the name of the warehouse journal template.];
                ApplicationArea=#Warehouse;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af lagerkladdetypen.;
                           ENU=Specifies a description of the warehouse journal template.];
                ApplicationArea=#Warehouse;
                SourceExpr=Description }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Warehouse;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Warehouse;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Warehouse;
                SourceExpr="Page ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontrolrapport, der udskrives, n†r du klikker p† Registrering og derefter Kontroller.;
                           ENU=Specifies the number of the test report that is printed when you click Registering, Test Report.];
                ApplicationArea=#Warehouse;
                SourceExpr="Test Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den registreringsrapport, der udskrives, n†r du klikker p† Registrering, Registrer og derefter p† Udskriv.;
                           ENU=Specifies the number of the registering report that is printed when you click Registering, Register and Print.];
                ApplicationArea=#Warehouse;
                SourceExpr="Registering Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 10  ;2   ;Field     ;
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

