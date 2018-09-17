OBJECT Page 1752 Data Classification Wizard
{
  OBJECT-PROPERTIES
  {
    Date=06-04-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.21441;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Assisterende opsëtningsvejledning til dataklassificering;
               ENU=Data Classification Assisted Setup Guide];
    InsertAllowed=No;
    DeleteAllowed=No;
    LinksAllowed=No;
    SourceTable=Table1180;
    PageType=NavigatePage;
    SourceTableTemporary=Yes;
    RefreshOnActivate=Yes;
    ShowFilter=No;
    OnInit=BEGIN
             LoadTopBanners;
           END;

    OnOpenPage=BEGIN
                 ResetControls;
                 ShowWorksheet := TRUE;
               END;

    OnAfterGetRecord=BEGIN
                       IF Status = Status::"Review Needed" THEN
                         StatusStyle := 'UnFavorable'
                       ELSE
                         StatusStyle := 'Favorable';

                       IF "Status 2" = "Status 2"::"Review Needed" THEN
                         SimilarFieldsStatusStyle := 'UnFavorable'
                       ELSE
                         SimilarFieldsStatusStyle := 'Favorable';

                       LedgerEntriesDefaultClassification := LedgerEntriesDefaultClassification::"Company Confidential";
                       TemplatesDefaultClassification := TemplatesDefaultClassification::Normal;
                       SetupTablesDefaultClassification := SetupTablesDefaultClassification::Normal;
                     END;

    ActionList=ACTIONS
    {
      { 16      ;0   ;ActionContainer;
                      ActionContainerType=NewDocumentItems }
      { 15      ;1   ;Action    ;
                      Name=ActionBack;
                      CaptionML=[DAN=Tilbage;
                                 ENU=Back];
                      ApplicationArea=#All;
                      Enabled=BackEnabled;
                      InFooterBar=Yes;
                      Image=PreviousRecord;
                      OnAction=BEGIN
                                 IF Step = Step::Verify THEN
                                   RESET;
                                 NextStep(TRUE);
                               END;
                                }
      { 14      ;1   ;Action    ;
                      Name=ActionNext;
                      CaptionML=[DAN=Nëste;
                                 ENU=Next];
                      ApplicationArea=#All;
                      Enabled=NextEnabled;
                      InFooterBar=Yes;
                      Image=NextRecord;
                      OnAction=VAR
                                 DataSensitivity@1001 : Record 2000000159;
                                 DataClassificationMgt@1000 : Codeunit 1750;
                               BEGIN
                                 CASE Step OF
                                   Step::"Choose Mode":
                                     BEGIN
                                       IF ImportModeSelected THEN BEGIN
                                         DataClassificationMgt.ImportExcelSheet;
                                         Step := Step::Finish;
                                         ResetControls;
                                         EXIT;
                                       END;
                                       IF ExportModeSelected THEN BEGIN
                                         DataClassificationMgt.ExportToExcelSheet;
                                         Step := Step::Finish;
                                         ResetControls;
                                         EXIT;
                                       END;
                                       IF ExpertModeSelected THEN BEGIN
                                         DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                                         IF DataSensitivity.ISEMPTY THEN
                                           DataClassificationMgt.FillDataSensitivityTable;
                                       END;
                                     END;
                                   Step::Apply:
                                     BEGIN
                                       DataClassificationMgt.SetTableClassifications(Rec);
                                       SETRANGE(Include,TRUE);
                                     END;
                                   Step::"Set Rules":
                                     BEGIN
                                       DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                                       DataSensitivity.SETRANGE("Data Sensitivity",DataSensitivity."Data Sensitivity"::Unclassified);
                                       DataSensitivity.SETFILTER("Table No",DataClassificationMgt.GetTableNoFilterForTablesWhoseNameContains('Entry'));
                                       DataClassificationMgt.SetSensitivities(DataSensitivity,LedgerEntriesDefaultClassification);
                                       DataSensitivity.SETFILTER("Table No",DataClassificationMgt.GetTableNoFilterForTablesWhoseNameContains('Template'));
                                       DataClassificationMgt.SetSensitivities(DataSensitivity,TemplatesDefaultClassification);
                                       DataSensitivity.SETFILTER("Table No",DataClassificationMgt.GetTableNoFilterForTablesWhoseNameContains('Setup'));
                                       DataClassificationMgt.SetSensitivities(DataSensitivity,SetupTablesDefaultClassification);
                                     END;
                                 END;

                                 NextStep(FALSE);
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=ActionFinish;
                      CaptionML=[DAN=Udfõr;
                                 ENU=Finish];
                      ApplicationArea=#All;
                      Enabled=FinishEnabled;
                      InFooterBar=Yes;
                      Image=Approve;
                      OnAction=BEGIN
                                 IF ShowWorksheet THEN
                                   PAGE.RUN(PAGE::"Data Classification Worksheet");
                                 CurrPage.CLOSE;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 42  ;1   ;Group     ;
                Visible=TopBannerVisible AND NOT FinishEnabled;
                Editable=FALSE;
                GroupType=Group }

    { 41  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesStandard."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 40  ;1   ;Group     ;
                Visible=TopBannerVisible AND FinishEnabled;
                Editable=FALSE;
                GroupType=Group }

    { 39  ;2   ;Field     ;
                ApplicationArea=#Basic,#Suite;
                SourceExpr=MediaResourcesDone."Media Reference";
                Editable=FALSE;
                ShowCaption=No }

    { 2   ;1   ;Group     ;
                Visible=Step = Step::Welcome;
                GroupType=Group }

    { 9   ;2   ;Group     ;
                CaptionML=[DAN=Velkommen til den assisterende opsëtningsvejledning til dataklassificering;
                           ENU=Welcome to the Data Classification Assisted Setup Guide];
                GroupType=Group;
                InstructionalTextML=[DAN="Dataklassificering, der er en vigtig del af beskyttelse af personlige og fõlsomme data, krëves ofte i lovgivning om beskyttelse af data. Klassificering kan gõre det nemmere at hente personlige data, f.eks. i forbindelse med anmodninger, og kan desuden udgõre et ekstra beskyttelseslag. Denne guide hjëlper dig med at klassificere fõlsomheden af data i tabeller og felter. ";
                                     ENU="Data classification is an important part of protecting the privacy of personal and sensitive data, and is often required by data privacy laws. Classification can make it easier to retrieve personal data, for example, in response to a request, and it can add another layer of protection. This guide helps you classify the sensitivity of the data in tables and fields. "] }

    { 12  ;2   ;Group     ;
                CaptionML=[DAN=Klassificeringer omfatter:;
                           ENU=Classifications include:];
                GroupType=Group;
                Layout=Rows }

    { 48  ;3   ;Field     ;
                CaptionML=[DAN=- Fõlsomme - private data, f.eks. politiske eller religiõs overbevisning.;
                           ENU=- Sensitive - Private data, such as political or religious beliefs.];
                ApplicationArea=#All }

    { 49  ;3   ;Field     ;
                CaptionML=[DAN=- Personlige - data, der kan bruges til at identificere nogen.;
                           ENU=- Personal - Any data that can be used to identify someone.];
                ApplicationArea=#All }

    { 50  ;3   ;Field     ;
                CaptionML=[DAN=-Virksomhedens fortrolige - forretningsdata, som du ikke õnsker at vise, f.eks. finansposter.;
                           ENU=- Company Confidential - Business data that you do not want to expose. For example, ledger entries.];
                ApplicationArea=#All }

    { 51  ;3   ;Field     ;
                CaptionML=[DAN=-Normal - data, der ikke hõrer til andre klassificeringer.;
                           ENU=- Normal - Data that does not belong to other classifications.];
                ApplicationArea=#All }

    { 60  ;2   ;Group     ;
                CaptionML=[DAN=Ansvarsfraskrivelse;
                           ENU=Legal disclaimer];
                GroupType=Group;
                InstructionalTextML=[DAN=Microsoft tilbyder kun denne funktion til dataklassificering for at gõre tingene nemmere for dig. Du har selv ansvaret for at klassificere dataene korrekt og overholde de love og regler, der gëlder for dig. Microsoft fraskriver sig ethvert ansvar i forbindelse med krav vedrõrende din klassificering af dataene.;
                                     ENU=Microsoft is providing this Data Classification feature as a matter of convenience only. It's your responsibility to classify the data appropriately and comply with any laws and regulations that are applicable to you. Microsoft disclaims all responsibility towards any claims related to your classification of the data.] }

    { 6   ;2   ;Field     ;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=HelpLbl;
                Editable=FALSE;
                Style=StandardAccent;
                StyleExpr=TRUE;
                OnDrillDown=BEGIN
                              HYPERLINK(HelpUrlTxt);
                            END;

                ShowCaption=No }

    { 3   ;1   ;Group     ;
                Visible=Step = Step::"Choose Mode";
                GroupType=Group }

    { 43  ;2   ;Group     ;
                CaptionML=[DAN=Lad os komme i gang;
                           ENU=Let's Get Started];
                GroupType=Group;
                InstructionalTextML=[DAN=Du kan eksportere data til et Excel-regneark, tilfõje klassificeringerne og derefter importere regnearket. Dette er eksempelvis nyttigt, nÜr du vil:;
                                     ENU=You can export data to an Excel worksheet, add the classifications, and then import the worksheet. For example, this is great for:] }

    { 44  ;3   ;Field     ;
                CaptionML=[DAN=- Tilfõje flere klassificeringer ad gangen.;
                           ENU=- Adding classifications in bulk.];
                ApplicationArea=#All;
                Importance=Additional;
                MultiLine=Yes }

    { 7   ;3   ;Field     ;
                CaptionML=[DAN=- Dele data med en partner, der klassificerer data for dig.;
                           ENU=- Sharing data with a partner who is classifying data for you.];
                ApplicationArea=#All }

    { 10  ;3   ;Field     ;
                CaptionML=[DAN=- Importerer klassificeringerne fra en anden virksomhed.;
                           ENU=- Importing the classifications from another company.];
                ApplicationArea=#All }

    { 47  ;3   ;Field     ;
                Name=<ExportModeSelected>;
                CaptionML=[DAN=EksportÇr klassificeringsdata til Excel;
                           ENU=Export Classification Data to Excel];
                ApplicationArea=#All;
                SourceExpr=ExportModeSelected;
                OnValidate=BEGIN
                             IF ExportModeSelected = TRUE THEN BEGIN
                               ExpertModeSelected := FALSE;
                               ImportModeSelected := FALSE;
                             END;

                             NextEnabled := ImportModeSelected OR ExpertModeSelected OR ExportModeSelected;
                           END;
                            }

    { 8   ;3   ;Field     ;
                CaptionML=[DAN=ImportÇr klassificeringsdata fra Excel;
                           ENU=Import Classification Data from Excel];
                ApplicationArea=#All;
                SourceExpr=ImportModeSelected;
                OnValidate=BEGIN
                             IF ImportModeSelected = TRUE THEN BEGIN
                               ExpertModeSelected := FALSE;
                               ExportModeSelected := FALSE;
                             END;

                             NextEnabled := ImportModeSelected OR ExpertModeSelected OR ExportModeSelected;
                           END;
                            }

    { 11  ;3   ;Group     ;
                GroupType=Group;
                InstructionalTextML=[DAN=Du kan ogsÜ fÜ vist en liste over tabeller og felter og klassificere dine data manuelt.;
                                     ENU=You can also view lists of tables and fields and manually classify your data.] }

    { 17  ;4   ;Field     ;
                CaptionML=[DAN=Klassificer data manuelt;
                           ENU=Classify Data Manually];
                ApplicationArea=#All;
                SourceExpr=ExpertModeSelected;
                OnValidate=BEGIN
                             IF ExpertModeSelected = TRUE THEN BEGIN
                               ImportModeSelected := FALSE;
                               ExportModeSelected := FALSE;
                             END;

                             NextEnabled := ImportModeSelected OR ExpertModeSelected OR ExportModeSelected;
                           END;
                            }

    { 33  ;1   ;Group     ;
                Visible=Step = Step::"Set Rules";
                GroupType=Group }

    { 61  ;2   ;Group     ;
                CaptionML=[DAN=Klassificere flere data, der er baseret pÜ brug;
                           ENU=Bulk-classify data based on its use];
                GroupType=Group }

    { 57  ;3   ;Group     ;
                CaptionML=[DAN=Eksempler:;
                           ENU=Examples:];
                GroupType=Group;
                InstructionalTextML=[DAN=Data fra bogfõring indeholder finansposter. Data i skabeloner, der er brugt til at oprette debitorer, kreditorer eller varer. Data i opsëtningstabeller der konfigurerer funktionalitet. Disse klassificeringer gëlder kun for felter, der i õjeblikket ikke er klassificerede. Vi anbefaler, at du gennemser felterne, fõr du anvender klassificeringerne.;
                                     ENU=Data from posting includes G/L entries. Data on templates used to create customers, vendors, or items. Data on setup tables that configure functionality. These classifications apply only to fields that are currently Unclassified. We recommend that you review the fields before you apply the classifications.] }

    { 53  ;3   ;Group     ;
                GroupType=Group;
                Layout=Columns }

    { 54  ;4   ;Field     ;
                CaptionML=[DAN=Data fra bogfõringen er:;
                           ENU=Data from posting is:];
                ApplicationArea=#All;
                SourceExpr=LedgerEntriesDefaultClassification }

    { 59  ;4   ;Field     ;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=ViewFieldsLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=VAR
                              DataSensitivity@1000 : Record 2000000159;
                              DataClassificationMgt@1001 : Codeunit 1750;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.SETFILTER("Table No",DataClassificationMgt.GetTableNoFilterForTablesWhoseNameContains('Entry'));
                              PAGE.RUN(PAGE::"Data Classification Worksheet",DataSensitivity);
                            END;
                             }

    { 55  ;4   ;Field     ;
                CaptionML=[DAN=Data om skabeloner er:;
                           ENU=Data on templates is:];
                ApplicationArea=#All;
                SourceExpr=TemplatesDefaultClassification }

    { 38  ;4   ;Field     ;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=ViewFieldsLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=VAR
                              DataSensitivity@1001 : Record 2000000159;
                              DataClassificationMgt@1000 : Codeunit 1750;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.SETFILTER("Table No",DataClassificationMgt.GetTableNoFilterForTablesWhoseNameContains('Template'));
                              PAGE.RUN(PAGE::"Data Classification Worksheet",DataSensitivity);
                            END;
                             }

    { 58  ;4   ;Field     ;
                CaptionML=[DAN=Dataene om opsëtningstabeller er:;
                           ENU=Data on setup tables is:];
                ApplicationArea=#All;
                SourceExpr=SetupTablesDefaultClassification }

    { 56  ;4   ;Field     ;
                DrillDown=Yes;
                ApplicationArea=#All;
                SourceExpr=ViewFieldsLbl;
                Editable=FALSE;
                Style=StrongAccent;
                StyleExpr=TRUE;
                OnDrillDown=VAR
                              DataSensitivity@1001 : Record 2000000159;
                              DataClassificationMgt@1000 : Codeunit 1750;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.SETFILTER("Table No",DataClassificationMgt.GetTableNoFilterForTablesWhoseNameContains('Setup'));
                              PAGE.RUN(PAGE::"Data Classification Worksheet",DataSensitivity);
                            END;
                             }

    { 4   ;1   ;Group     ;
                Visible=Step = Step::Apply;
                GroupType=Group }

    { 18  ;2   ;Group     ;
                CaptionML=[DAN=Vëlg de tabeller, som du vil klassificere;
                           ENU=Choose the tables that you want to classify];
                GroupType=Group;
                InstructionalTextML=[DAN=NÜr du klassificerer en tabel, gëlder klassificeringen alle felter i tabellen. Du kan vëlge en tabel for at ëndre klassificeringen af de enkelte felter.;
                                     ENU=When you classify a table, the classification applies to all fields in the table. You can choose a table to change classifications for individual fields.] }

    { 19  ;3   ;Field     ;
                ApplicationArea=#All }

    { 20  ;3   ;Group     ;
                GroupType=Repeater }

    { 21  ;4   ;Field     ;
                Name=Include;
                ApplicationArea=#All;
                SourceExpr=Include }

    { 5   ;4   ;Field     ;
                Name=Entity;
                DrillDown=No;
                CaptionML=[DAN=Dataemne;
                           ENU=Data Subject];
                ApplicationArea=#All;
                SourceExpr="Table Caption";
                Editable=FALSE }

    { 23  ;4   ;Field     ;
                Name=Default Data Sensitivity;
                ApplicationArea=#All;
                SourceExpr="Default Data Sensitivity" }

    { 24  ;1   ;Group     ;
                Visible=Step = Step::Verify;
                GroupType=Group }

    { 28  ;2   ;Group     ;
                CaptionML=[DAN=Godt klaret! Nu skal du klassificere de enkelte felter;
                           ENU=Good work! Now classify individual fields];
                GroupType=Group;
                InstructionalTextML=[DAN="Standardklassificeringen er fõjet til tabellerne. Du kan nu klassificere de enkelte felter i tabellerne og de enheder, der er relateret til tabellerne. ";
                                     ENU="The default classification has been added to the tables. Now you can classify individual fields in the tables, and  the entities that relate to the tables. "] }

    { 45  ;2   ;Group     ;
                CaptionML=[DAN=Gennemse alle enhedernes klassificeringer, fõr du fortsëtter!;
                           ENU=Review the classifications for all the entities before you continue!];
                GroupType=Group }

    { 25  ;2   ;Group     ;
                GroupType=Repeater }

    { 26  ;3   ;Field     ;
                Name=Entity 2;
                DrillDown=No;
                CaptionML=[DAN=Dataemne;
                           ENU=Data Subject];
                ApplicationArea=#All;
                SourceExpr="Table Caption";
                Editable=FALSE }

    { 32  ;3   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Fields;
                Editable=FALSE;
                Style=StandardAccent;
                StyleExpr=TRUE;
                OnDrillDown=VAR
                              DataSensitivity@1000 : Record 2000000159;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.FILTERGROUP(2);
                              DataSensitivity.SETRANGE("Table No","Table No.");
                              PAGE.RUNMODAL(PAGE::"Data Classification Worksheet",DataSensitivity);

                              Reviewed := TRUE;
                              Status := Status::Reviewed;
                              CurrPage.UPDATE;
                            END;
                             }

    { 34  ;3   ;Field     ;
                ApplicationArea=#All;
                SourceExpr=Status;
                Editable=FALSE;
                StyleExpr=StatusStyle;
                OnDrillDown=VAR
                              DataSensitivity@1000 : Record 2000000159;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.FILTERGROUP(2);
                              DataSensitivity.SETRANGE("Table No","Table No.");
                              PAGE.RUNMODAL(PAGE::"Data Classification Worksheet",DataSensitivity);

                              Reviewed := TRUE;
                              Status := Status::Reviewed;
                              CurrPage.UPDATE;
                            END;
                             }

    { 36  ;1   ;Group     ;
                Visible=Step = Step::"Verify Related Fields";
                GroupType=Group }

    { 37  ;2   ;Group     ;
                CaptionML=[DAN=Vi er snart fërdige!;
                           ENU=We're getting there!];
                GroupType=Group;
                InstructionalTextML=[DAN=Gennemse klassificeringerne af lignende felter, fõr du fortsëtter.;
                                     ENU=Review the classifications for similar fields before you continue.] }

    { 52  ;2   ;Group     ;
                GroupType=Repeater }

    { 35  ;3   ;Field     ;
                CaptionML=[DAN=Felter;
                           ENU=Fields];
                ApplicationArea=#All;
                SourceExpr="Similar Fields Label";
                Editable=FALSE;
                OnDrillDown=VAR
                              DataSensitivity@1002 : Record 2000000159;
                              DataClassificationMgt@1000 : Codeunit 1750;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.SETRANGE("Table No","Table No.");
                              DataSensitivity.SETFILTER("Data Sensitivity",STRSUBSTNO('%1|%2',
                                  DataSensitivity."Data Sensitivity"::Personal,
                                  DataSensitivity."Data Sensitivity"::Sensitive));
                              DataClassificationMgt.FindSimilarFields(DataSensitivity);
                              PAGE.RUNMODAL(PAGE::"Data Classification Worksheet",DataSensitivity);

                              "Similar Fields Reviewed" := TRUE;
                              "Status 2" := "Status 2"::Reviewed;
                              CurrPage.UPDATE;
                            END;
                             }

    { 22  ;3   ;Field     ;
                Name=Status 2;
                CaptionML=[DAN=Status;
                           ENU=Status];
                ApplicationArea=#All;
                SourceExpr="Status 2";
                Editable=FALSE;
                StyleExpr=SimilarFieldsStatusStyle;
                OnDrillDown=VAR
                              DataSensitivity@1000 : Record 2000000159;
                              DataClassificationMgt@1001 : Codeunit 1750;
                            BEGIN
                              DataSensitivity.SETRANGE("Company Name",COMPANYNAME);
                              DataSensitivity.SETRANGE("Table No","Table No.");
                              DataSensitivity.SETFILTER("Data Sensitivity",STRSUBSTNO('%1|%2',
                                  DataSensitivity."Data Sensitivity"::Personal,
                                  DataSensitivity."Data Sensitivity"::Sensitive));
                              DataClassificationMgt.FindSimilarFields(DataSensitivity);
                              PAGE.RUNMODAL(PAGE::"Data Classification Worksheet",DataSensitivity);

                              "Similar Fields Reviewed" := TRUE;
                              "Status 2" := "Status 2"::Reviewed;
                              CurrPage.UPDATE;
                            END;
                             }

    { 29  ;1   ;Group     ;
                Visible=(Step = Step::Finish) AND NOT ExportModeSelected;
                GroupType=Group }

    { 30  ;2   ;Group     ;
                CaptionML=[DAN=Det var det hele;
                           ENU=That's it];
                GroupType=Group;
                InstructionalTextML=[DAN=Vi har anvendt klassificeringerne pÜ dine data. Du kan evt. gennemse og opdatere klassificeringerne i regnearket Dataklassificering.;
                                     ENU=We have applied the classifications to your data. If you want, you can review and update the classifications in the Data Classification Worksheet.] }

    { 31  ;3   ;Field     ;
                Name=<Control30>;
                CaptionML=[DAN=èbn regneark til dataklassificering;
                           ENU=Open Data Classification Worksheet];
                ApplicationArea=#All;
                SourceExpr=ShowWorksheet }

    { 27  ;1   ;Group     ;
                Visible=(Step = Step::Finish) AND ExportModeSelected;
                GroupType=Group }

    { 46  ;2   ;Group     ;
                CaptionML=[DAN=Det var det hele;
                           ENU=That's it];
                GroupType=Group;
                InstructionalTextML=[DAN=Excel-regnearket er klar, og du kan begynde at klassificere dine data. NÜr du er fërdig, skal du kõre denne guide igen for at importere det opdaterede Excel-regneark og anvende klassificeringerne.;
                                     ENU=The Excel worksheet is ready, and you can start classifying your data.  When you are done, run this guide again to import the updated Excel worksheet and apply the classifications.] }

  }
  CODE
  {
    VAR
      HelpUrlTxt@1000 : TextConst '@@@=Locked;DAN="https://go.microsoft.com/fwlink/?linkid=869249";ENU="https://go.microsoft.com/fwlink/?linkid=869249"';
      HelpLbl@1003 : TextConst 'DAN=FÜ mere at vide;ENU=Learn more';
      ReviewFieldsErr@1015 : TextConst 'DAN=Du skal gennemse felternes klassificeringer, fõr du fortsëtter.;ENU=You must review the classifications for fields before you can continue.';
      ReviewSimilarFieldsErr@1016 : TextConst 'DAN=Du skal gennemse klassificeringerne af lignende felter, fõr du fortsëtter.;ENU=You must review the classifications for similar fields before you can continue.';
      MediaRepositoryStandard@1022 : Record 9400;
      MediaRepositoryDone@1021 : Record 9400;
      MediaResourcesStandard@1020 : Record 2000000182;
      MediaResourcesDone@1019 : Record 2000000182;
      ClientTypeManagement@1024 : Codeunit 4;
      TopBannerVisible@1018 : Boolean;
      Step@1010 : 'Welcome,Choose Mode,Set Rules,Apply,Verify,Verify Related Fields,Finish';
      StatusStyle@1001 : Text;
      SimilarFieldsStatusStyle@1002 : Text;
      NextEnabled@1008 : Boolean;
      BackEnabled@1007 : Boolean;
      FinishEnabled@1006 : Boolean;
      ShowWorksheet@1005 : Boolean;
      ImportModeSelected@1027 : Boolean;
      ExpertModeSelected@1028 : Boolean;
      ExportModeSelected@1011 : Boolean;
      LedgerEntriesDefaultClassification@1009 : 'Unclassified,Sensitive,Personal,Company Confidential,Normal';
      SetupTablesDefaultClassification@1012 : 'Unclassified,Sensitive,Personal,Company Confidential,Normal';
      TemplatesDefaultClassification@1013 : 'Unclassified,Sensitive,Personal,Company Confidential,Normal';
      ViewFieldsLbl@1031 : TextConst 'DAN=Vis felter;ENU=View fields';

    LOCAL PROCEDURE NextStep@18(Backward@1000 : Boolean);
    BEGIN
      IF NOT Backward THEN
        CheckMandatoryActions;

      IF Backward THEN BEGIN
        IF (Step = Step::Finish) AND (ImportModeSelected OR ExportModeSelected) THEN
          Step := Step::"Choose Mode"
        ELSE
          Step += -1;
      END ELSE
        Step += 1;
      ResetControls;
    END;

    LOCAL PROCEDURE ResetControls@25();
    VAR
      DataClassificationMgt@1000 : Codeunit 1750;
    BEGIN
      BackEnabled := TRUE;
      NextEnabled := TRUE;
      FinishEnabled := FALSE;
      RESET;

      IF ISEMPTY THEN
        DataClassificationMgt.OnGetPrivacyMasterTables(Rec);

      CASE Step OF
        Step::Welcome:
          BackEnabled := FALSE;
        Step::"Choose Mode":
          NextEnabled := ImportModeSelected OR ExpertModeSelected OR ExportModeSelected;
        Step::Verify,
        Step::"Verify Related Fields":
          SETRANGE(Include,TRUE);
        Step::Finish:
          BEGIN
            FinishEnabled := TRUE;
            NextEnabled := FALSE;
          END;
      END;
    END;

    LOCAL PROCEDURE CheckMandatoryActions@4();
    BEGIN
      IF Step = Step::"Verify Related Fields" THEN BEGIN
        SETRANGE("Similar Fields Reviewed",FALSE);
        IF FINDFIRST THEN
          ERROR(ReviewSimilarFieldsErr);
      END;
      IF Step = Step::Verify THEN BEGIN
        SETRANGE(Reviewed,FALSE);
        IF FINDFIRST THEN
          ERROR(ReviewFieldsErr);
      END;
    END;

    LOCAL PROCEDURE LoadTopBanners@40();
    BEGIN
      IF MediaRepositoryStandard.GET('AssistedSetup-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType)) AND
         MediaRepositoryDone.GET('AssistedSetupDone-NoText-400px.png',FORMAT(ClientTypeManagement.GetCurrentClientType))
      THEN
        IF MediaResourcesStandard.GET(MediaRepositoryStandard."Media Resources Ref") AND
           MediaResourcesDone.GET(MediaRepositoryDone."Media Resources Ref")
        THEN
          TopBannerVisible := MediaResourcesDone."Media Reference".HASVALUE;
    END;

    BEGIN
    END.
  }
}

