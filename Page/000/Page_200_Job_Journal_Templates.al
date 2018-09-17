OBJECT Page 200 Job Journal Templates
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagskladdetyper;
               ENU=Job Journal Templates];
    SourceTable=Table209;
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
                      RunObject=Page 276;
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
                ToolTipML=[DAN=Angiver navnet p† denne kladdetype. Du kan angive op til 10 tegn, b†de tal og bogstaver.;
                           ENU=Specifies the name of this journal template. You can enter a maximum of 10 characters, both numbers and letters.];
                ApplicationArea=#Jobs;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af sagskladdetypen, s† du nemt kan finde den.;
                           ENU=Specifies a description of the job journal template for easy identification.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den nummerserie, som bruges til at knytte post- eller recordnumre til nye poster eller records.;
                           ENU=Specifies the number series from which entry or record numbers are assigned to new entries or records.];
                ApplicationArea=#Jobs;
                SourceExpr="No. Series" }

    { 33  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden p† den nummerserie, der skal bruges til at tildele bilagsnumre til finansposter, der bogf›res fra kladder ved hj‘lp af denne type.;
                           ENU=Specifies the code for the number series that will be used to assign document numbers to ledger entries that are posted from journals using this template.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting No. Series" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om kladden skal indeholde gentagelsesposter. Lad feltet v‘re tomt, hvis kladden ikke skal v‘re en gentagelseskladde.;
                           ENU=Specifies whether the journal is to contain recurring entries. Leave the field blank if the journal should not contain recurring entries.];
                ApplicationArea=#Jobs;
                SourceExpr=Recurring }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det kildespor, der angiver, hvor posten blev oprettet.;
                           ENU=Specifies the source code that specifies where the entry was created.];
                ApplicationArea=#Jobs;
                SourceExpr="Source Code";
                OnValidate=BEGIN
                             SourceCodeOnAfterValidate;
                           END;
                            }

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
                ToolTipML=[DAN=Angiver den kontrolrapport, der udskrives, n†r du opretter en kontrolrapport.;
                           ENU=Specifies the test report that is printed when you create a Test Report.];
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
                ToolTipML=[DAN=Angiver, hvilken journalrapport du vil have tilknyttet denne kladde. Mark‚r feltet for at f† vist de tilg‘ngelige id'er.;
                           ENU=Specifies the posting report you want to be associated with this journal. To see the available IDs, choose the field.];
                ApplicationArea=#Jobs;
                SourceExpr="Posting Report ID";
                Visible=FALSE;
                LookupPageID=Objects }

    { 27  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den bogf›ringsrapport, der udskrives, n†r du udskriver sagskladden.;
                           ENU=Specifies the name of the posting report that is printed when you print the job journal.];
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

    LOCAL PROCEDURE SourceCodeOnAfterValidate@19004618();
    BEGIN
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

