OBJECT Page 275 Job Journal Template List
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
    CaptionML=[DAN=Sagskladdetypeover.;
               ENU=Job Journal Template List];
    SourceTable=Table209;
    PageType=List;
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† denne kladdetype. Du kan angive op til 10 tegn, b†de tal og bogstaver.;
                           ENU=Specifies the name of this journal template. You can enter a maximum of 10 characters, both numbers and letters.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af sagskladdetypen, s† du nemt kan finde den.;
                           ENU=Specifies a description of the job journal template for easy identification.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den kontrolrapport, der udskrives, n†r du opretter en kontrolrapport.;
                           ENU=Specifies the test report that is printed when you create a Test Report.];
                ApplicationArea=#Jobs;
                SourceExpr="Test Report ID";
                Visible=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den side, der bruges til at vise den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the number of the page that is used to show the journal or worksheet that uses the template.];
                ApplicationArea=#Jobs;
                SourceExpr="Page ID";
                Visible=FALSE }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken journalrapport du vil have tilknyttet denne kladde. Mark‚r feltet for at f† vist de tilg‘ngelige id'er.;
                           ENU=Specifies the posting report you want to be associated with this journal. To see the available IDs, choose the field.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Report ID";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om en rapport udskrives automatisk ved bogf›ring.;
                           ENU=Specifies whether a report is printed automatically when you post.];
                ApplicationArea=#Jobs;
                SourceExpr="Force Posting Report";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Source Code";
                Visible=FALSE }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver †rsagskoden som et supplerende kildespor, der hj‘lper til at spore posten.;
                           ENU=Specifies the reason code, a supplementary source code that enables you to trace the entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Reason Code";
                Visible=FALSE }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den kontrolrapport, du har valgt i feltet Kontrolrapport-id.;
                           ENU=Specifies the name of the test report that you selected in the Test Report ID field.];
                ApplicationArea=#Jobs;
                SourceExpr="Test Report Caption";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det viste navn p† den kladde eller det regneark, der bruger skabelonen.;
                           ENU=Specifies the displayed name of the journal or worksheet that uses the template.];
                ApplicationArea=#Jobs;
                SourceExpr="Page Caption";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† den bogf›ringsrapport, der udskrives, n†r du udskriver sagskladden.;
                           ENU=Specifies the name of the posting report that is printed when you print the job journal.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Report Caption";
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

