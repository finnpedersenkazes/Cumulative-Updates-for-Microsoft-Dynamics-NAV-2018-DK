OBJECT Page 1002 Job Task Lines
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sagsopgavelinjer;
               ENU=Job Task Lines];
    SaveValues=Yes;
    SourceTable=Table1001;
    DataCaptionFields=Job No.;
    PageType=List;
    OnAfterGetRecord=BEGIN
                       DescriptionIndent := Indentation;
                       StyleIsStrong := "Job Task Type" <> "Job Task Type"::Posting;
                     END;

    OnNewRecord=BEGIN
                  ClearTempDim;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 56      ;1   ;ActionGroup;
                      CaptionML=[DAN=Sagsopg&ave;
                                 ENU=&Job Task];
                      Image=Task }
      { 20      ;2   ;Action    ;
                      Name=JobPlanningLines;
                      ShortCutKey=Shift+Ctrl+P;
                      CaptionML=[DAN=Sags&planl‘gningslinjer;
                                 ENU=Job &Planning Lines];
                      ToolTipML=[DAN=Vis alle planl‘gningslinjer for sagen. Du kan bruge dette vindue til at planl‘gge, hvilke varer, ressourcer og finansudgifter du forventer at bruge p† en sag (budget), eller du kan angive det faktiske bel›b, som du har aftalt, at debitoren skal betale for sagen (fakturerbar).;
                                 ENU=View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that they should pay for the job (billable).];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JobLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 JobPlanningLine@1000 : Record 1003;
                                 JobPlanningLines@1001 : Page 1007;
                               BEGIN
                                 TESTFIELD("Job Task Type","Job Task Type"::Posting);
                                 TESTFIELD("Job No.");
                                 TESTFIELD("Job Task No.");
                                 JobPlanningLine.FILTERGROUP(2);
                                 JobPlanningLine.SETRANGE("Job No.","Job No.");
                                 JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                                 JobPlanningLine.FILTERGROUP(0);
                                 JobPlanningLines.SetJobTaskNoVisible(FALSE);
                                 JobPlanningLines.SETTABLEVIEW(JobPlanningLine);
                                 JobPlanningLines.RUN;
                               END;
                                }
      { 16      ;2   ;Action    ;
                      Name=JobTaskStatistics;
                      ShortCutKey=F7;
                      CaptionML=[DAN=&Statistik for sagsopgaver;
                                 ENU=Job Task &Statistics];
                      ToolTipML=[DAN=Vis sagsopgavens statistik.;
                                 ENU=View statistics for the job task.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1024;
                      RunPageLink=Job No.=FIELD(Job No.),
                                  Job Task No.=FIELD(Job Task No.);
                      Image=StatisticsDocument }
      { 18      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Sagsopga&vekort;
                                 ENU=Job &Task Card];
                      ToolTipML=[DAN=Vis detaljerede oplysninger om en sagsopgave, f.eks. beskrivelsen af opgaven samt opgavetypen, som kan v‘re en overskrift, en bogf›ring, en fra-sum, en til-sum eller en sum.;
                                 ENU=View detailed information about a job task, such as the description of the task and the type, which can be either a heading, a posting, a begin-total, an end-total, or a total.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1003;
                      RunPageLink=Job No.=FIELD(Job No.),
                                  Job Task No.=FIELD(Job Task No.);
                      Image=Task }
      { 65      ;2   ;Separator ;
                      CaptionML=[DAN=-;
                                 ENU=-] }
      { 19      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      Image=Dimensions }
      { 66      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner - enkelt;
                                 ENU=Dimensions-&Single];
                      ToolTipML=[DAN=F† vist eller rediger de enkelte s‘t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1005;
                      RunPageLink=Job No.=FIELD(Job No.),
                                  Job Task No.=FIELD(Job Task No.);
                      Image=Dimensions }
      { 21      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Jobs;
                      Image=DimensionSets;
                      OnAction=VAR
                                 JobTask@1000 : Record 1001;
                                 JobTaskDimensionsMultiple@1001 : Page 1006;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(JobTask);
                                 JobTaskDimensionsMultiple.SetMultiJobTask(JobTask);
                                 JobTaskDimensionsMultiple.RUNMODAL;
                               END;
                                }
      { 38      ;1   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Documents }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Salgs&fakturaer/kreditnotaer;
                                 ENU=Sales &Invoices/Credit Memos];
                      ToolTipML=[DAN=Vis salgsfakturaer eller salgskreditnotaer, der er relateret til den valgte sagsopgave.;
                                 ENU=View sales invoices or sales credit memos that are related to the selected job task.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 JobInvoices@1000 : Page 1029;
                               BEGIN
                                 JobInvoices.SetPrJobTask(Rec);
                                 JobInvoices.RUNMODAL;
                               END;
                                }
      { 46      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&IA;
                                 ENU=W&IP];
                      Image=WIP }
      { 10      ;2   ;Action    ;
                      CaptionML=[DAN=&VIA-poster;
                                 ENU=&WIP Entries];
                      ToolTipML=[DAN=Vis poster for den sag, der er bogf›rt som igangv‘rende arbejde.;
                                 ENU=View entries for the job that are posted as work in process.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1008;
                      RunPageView=SORTING(Job No.,Job Posting Group,WIP Posting Date);
                      RunPageLink=Job No.=FIELD(Job No.);
                      Image=WIPEntries }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=VIA-&finansposter;
                                 ENU=WIP &G/L Entries];
                      ToolTipML=[DAN=Vis sagens finansposter for igangv‘rende arbejde.;
                                 ENU=View the job's WIP G/L entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1009;
                      RunPageView=SORTING(Job No.);
                      RunPageLink=Job No.=FIELD(Job No.);
                      Image=WIPLedger }
      { 35      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 6       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Sags&poster;
                                 ENU=Job Ledger E&ntries];
                      ToolTipML=[DAN=Vis sagsposterne.;
                                 ENU=View the job ledger entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageView=SORTING(Job No.,Job Task No.);
                      RunPageLink=Job No.=FIELD(Job No.),
                                  Job Task No.=FIELD(Job Task No.);
                      Image=JobLedger }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 31      ;1   ;ActionGroup;
                      CaptionML=[DAN=Nye dokumenter;
                                 ENU=New Documents];
                      Image=Invoice }
      { 15      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opret &salgsfaktura;
                                 ENU=Create &Sales Invoice];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at oprette salgsfakturaer for de involverede sagsopgaver.;
                                 ENU=Use a batch job to help you create sales invoices for the involved job tasks.];
                      ApplicationArea=#Jobs;
                      Image=JobSalesInvoice;
                      OnAction=VAR
                                 Job@1000 : Record 167;
                                 JobTask@1002 : Record 1001;
                               BEGIN
                                 TESTFIELD("Job No.");
                                 Job.GET("Job No.");
                                 IF Job.Blocked = Job.Blocked::All THEN
                                   Job.TestBlocked;

                                 JobTask.SETRANGE("Job No.",Job."No.");
                                 IF "Job Task No." <> '' THEN
                                   JobTask.SETRANGE("Job Task No.","Job Task No.");

                                 REPORT.RUNMODAL(REPORT::"Job Create Sales Invoice",TRUE,FALSE,JobTask);
                               END;
                                }
      { 4       ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 17      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Opdel &planl‘gningslinjer;
                                 ENU=Split &Planning Lines];
                      ToolTipML=[DAN=Opdel planl‘gningslinjer af typen Budget og Fakturerbar til to separate planl‘gningslinjer: Budget og Fakturerbar.;
                                 ENU=Split planning lines of type Budget and Billable into two separate planning lines: Budget and Billable.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Splitlines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Job@1000 : Record 167;
                                 JobTask@1002 : Record 1001;
                               BEGIN
                                 TESTFIELD("Job No.");
                                 Job.GET("Job No.");
                                 IF Job.Blocked = Job.Blocked::All THEN
                                   Job.TestBlocked;

                                 TESTFIELD("Job Task No.");
                                 JobTask.SETRANGE("Job No.",Job."No.");
                                 JobTask.SETRANGE("Job Task No.","Job Task No.");

                                 REPORT.RUNMODAL(REPORT::"Job Split Planning Line",TRUE,FALSE,JobTask);
                               END;
                                }
      { 22      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Flyt datoer;
                                 ENU=Change &Dates];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at flytte planl‘gningslinjer i en sag fra et datointerval til et andet.;
                                 ENU=Use a batch job to help you move planning lines on a job from one date interval to another.];
                      ApplicationArea=#Jobs;
                      Image=ChangeDate;
                      OnAction=VAR
                                 Job@1000 : Record 167;
                                 JobTask@1002 : Record 1001;
                               BEGIN
                                 TESTFIELD("Job No.");
                                 Job.GET("Job No.");
                                 IF Job.Blocked = Job.Blocked::All THEN
                                   Job.TestBlocked;

                                 JobTask.SETRANGE("Job No.",Job."No.");
                                 IF "Job Task No." <> '' THEN
                                   JobTask.SETRANGE("Job Task No.","Job Task No.");

                                 REPORT.RUNMODAL(REPORT::"Change Job Dates",TRUE,FALSE,JobTask);
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=<Action7>;
                      CaptionML=[DAN=I&ndryk sagsopgaver;
                                 ENU=I&ndent Job Tasks];
                      ToolTipML=[DAN=Flyt de valgte linjer i en position for at vise, at opgaverne er underkategorier for andre opgaver. Sagsopgaver, der er sammentalt, ligger mellem et par tilsvarende Fra sum- og Til sum-sagsopgaver.;
                                 ENU=Move the selected lines in one position to show that the tasks are subcategories of other tasks. Job tasks that are totaled are the ones that lie between one pair of corresponding Begin-Total and End-Total job tasks.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 1003;
                      Image=Indent }
      { 23      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Kopier;
                                 ENU=&Copy];
                      ActionContainerType=NewDocumentItems;
                      Image=Copy }
      { 32      ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier sagsplanl‘gningslinjer &fra...;
                                 ENU=Copy Job Planning Lines &from...];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at kopiere planl‘gningslinjer fra en sagsopgave til en anden. Du kan kopiere fra en sagsopgave i den sag, du arbejder med, eller fra en sagsopgave, der er tilknyttet en anden sag.;
                                 ENU=Use a batch job to help you copy planning lines from one job task to another. You can copy from a job task within the job you are working with or from a job task linked to a different job.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=CopyToTask;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CopyJobPlanningLines@1000 : Page 1042;
                               BEGIN
                                 TESTFIELD("Job Task Type","Job Task Type"::Posting);
                                 CopyJobPlanningLines.SetToJobTask(Rec);
                                 CopyJobPlanningLines.RUNMODAL;
                               END;
                                }
      { 33      ;3   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier sagsplanl‘gningslinjer &til...;
                                 ENU=Copy Job Planning Lines &to...];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at kopiere planl‘gningslinjer fra en sagsopgave til en anden. Du kan kopiere fra en sagsopgave i den sag, du arbejder med, eller fra en sagsopgave, der er tilknyttet en anden sag.;
                                 ENU=Use a batch job to help you copy planning lines from one job task to another. You can copy from a job task within the job you are working with or from a job task linked to a different job.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=CopyFromTask;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CopyJobPlanningLines@1000 : Page 1042;
                               BEGIN
                                 TESTFIELD("Job Task Type","Job Task Type"::Posting);
                                 CopyJobPlanningLines.SetFromJobTask(Rec);
                                 CopyJobPlanningLines.RUNMODAL;
                               END;
                                }
      { 25      ;2   ;ActionGroup;
                      Name=<Action13>;
                      CaptionML=[DAN=V&IA;
                                 ENU=W&IP];
                      ActionContainerType=NewDocumentItems;
                      Image=WIP }
      { 3       ;3   ;Action    ;
                      Name=<Action48>;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Beregn VIA;
                                 ENU=&Calculate WIP];
                      ToolTipML=[DAN=Udf›r k›rslen Beregn VIA - finansafstemning.;
                                 ENU=Run the Job Calculate WIP batch job.];
                      ApplicationArea=#Jobs;
                      Image=CalculateWIP;
                      OnAction=VAR
                                 Job@1002 : Record 167;
                               BEGIN
                                 TESTFIELD("Job No.");
                                 Job.GET("Job No.");
                                 Job.SETRANGE("No.",Job."No.");
                                 REPORT.RUNMODAL(REPORT::"Job Calculate WIP",TRUE,FALSE,Job);
                               END;
                                }
      { 11      ;3   ;Action    ;
                      Name=<Action49>;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogf›r VIA;
                                 ENU=&Post WIP to G/L];
                      ToolTipML=[DAN=Udf›r k›rslen Bogf›r VIA - finansafstemning.;
                                 ENU=Run the Job Post WIP to G/L batch job.];
                      ApplicationArea=#Jobs;
                      Image=PostOrder;
                      OnAction=VAR
                                 Job@1001 : Record 167;
                               BEGIN
                                 TESTFIELD("Job No.");
                                 Job.GET("Job No.");
                                 Job.SETRANGE("No.",Job."No.");
                                 REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L",TRUE,FALSE,Job);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903776506;1 ;Action    ;
                      CaptionML=[DAN=Sag - realiseret/budget;
                                 ENU=Job Actual to Budget];
                      ToolTipML=[DAN=Sammenlign de budgetterede og faktiske forbrugsbel›b for valgte sager. Alle linjer i den valgte sag viser antal, samlede omkostning og linjebel›b.;
                                 ENU=Compare budgeted and usage amounts for selected jobs. All lines of the selected job show quantity, total cost, and line amount.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1009;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901542506;1 ;Action    ;
                      CaptionML=[DAN=Sagsanalyse;
                                 ENU=Job Analysis];
                      ToolTipML=[DAN=Analys‚r sagen, f.eks. de budgetterede priser, forbrugspriser og fakturerbare priser, og sammenlign derefter de tre s‘t priser.;
                                 ENU=Analyze the job, such as the budgeted prices, usage prices, and billable prices, and then compares the three sets of prices.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1008;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902943106;1 ;Action    ;
                      CaptionML=[DAN=Sag - planl‘gningslinjer;
                                 ENU=Job - Planning Lines];
                      ToolTipML=[DAN=Vis alle planl‘gningslinjer for sagen. Du kan bruge dette vindue til at planl‘gge, hvilke varer, ressourcer og finansudgifter du forventer at bruge p† en sag (budget), eller du kan angive det faktiske bel›b, som du har aftalt, at debitoren skal betale for sagen (fakturerbar).;
                                 ENU=View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1006;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903186006;1 ;Action    ;
                      CaptionML=[DAN=Sag - foresl†et fakturering;
                                 ENU=Job - Suggested Billing];
                      ToolTipML=[DAN=Vis en liste over alle sager, grupperet efter debitor, hvor meget debitoren allerede har faktureret, og hvor meget der mangler at blive faktureret, dvs. den foresl†ede fakturering.;
                                 ENU=View a list of all jobs, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1011;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905285006;1 ;Action    ;
                      CaptionML=[DAN=Sag - kontokort;
                                 ENU=Jobs - Transaction Detail];
                      ToolTipML=[DAN=Vis alle de bogf›ringer med poster for en bestemt sag i en n‘rmere angivet periode, som er blevet debiteret en bestemt sag. For hver sag samment‘lles salgsposter og forbrugsposter hver for sig.;
                                 ENU=View all postings with entries for a selected job for a selected period, which have been charged to a certain job. At the end of each job list, the amounts are totaled separately for the Sales and Usage entry types.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1007;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                IndentationColumnName=DescriptionIndent;
                IndentationControls=Description;
                GroupType=Repeater }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den relaterede sag.;
                           ENU=Specifies the number of the related job.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af sagsopgaven. Du kan indtaste alt, der giver mening i beskrivelsen af opgaven. Beskrivelsen kopieres og bruges i beskrivelser p† sagsplanl‘gningslinjen.;
                           ENU=Specifies a description of the job task. You can enter anything that is meaningful in describing the task. The description is copied and used in descriptions on the job planning line.];
                ApplicationArea=#Jobs;
                SourceExpr=Description;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontoens form†l. Nyoprettede konti f†r automatisk tildelt kontotypen Bogf›ring, men det kan du ‘ndre. V‘lg feltet for at v‘lge ‚n af f›lgende fem indstillinger:;
                           ENU=Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this. Choose the field to select one of the following five options:];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task Type" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et interval eller en liste over sagsopgavenumre.;
                           ENU=Specifies an interval or a list of job task numbers.];
                ApplicationArea=#Jobs;
                SourceExpr=Totaling }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagsbogf›ringsgruppen for opgaven.;
                           ENU=Specifies the job posting group of the task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Posting Group" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de sagsopgaver, du vil gruppere ved beregning af Igangv‘rende arbejde (VIA) og Registrering.;
                           ENU=Specifies the job tasks you want to group together when calculating Work In Process (WIP) and Recognition.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP-Total" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† beregningsmetoden Igangv‘rende arbejde, der er tilknyttet en sag. V‘rdien i dette felt kommer fra den VIA-metode, der er angivet p† jobkortet.;
                           ENU=Specifies the name of the Work in Process calculation method that is associated with a job. The value in this field comes from the WIP method specified on the job card.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Method" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for sagsopgaven. Datoen er baseret p† datoen i linjen for den relaterede opgaveplanl‘gning.;
                           ENU=Specifies the start date for the job task. The date is based on the date on the related job planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="Start Date" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for sagsopgaven. Datoen er baseret p† datoen i linjen for den relaterede opgaveplanl‘gning.;
                           ENU=Specifies the end date for the job task. The date is based on the date on the related job planning line.];
                ApplicationArea=#Jobs;
                SourceExpr="End Date" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede budgetterede omkostning i den lokale valuta for sagsopgaven for den tidsperiode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in the local currency, the total budgeted cost for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Schedule (Total Cost)" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede budgetterede pris i den lokale valuta for sagsopgaven for den tidsperiode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in local currency, the total budgeted price for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Schedule (Total Price)" }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede kostbel›b i den lokale valuta for de brugte varer, ressourcer og finansudgifter, der er bogf›rt for sagsopgaven i den tidsperiode, som er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in local currency, the total cost of the usage of items, resources and general ledger expenses posted on the job task during the time period in the Posting Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Usage (Total Cost)" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den samlede pris i den lokale valuta for forbruget af varer, ressourcer og finansudgifter, der er bogf›rt for sagsopgaven i den periode, som er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in the local currency, the total price of the usage of items, resources and general ledger expenses posted on the job task during the time period in the Posting Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Usage (Total Price)" }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (kostbel›b i alt);
                           ENU=Billable (Total Cost)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare omkostning i den lokale valuta for sagsopgaven i den periode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in local currency, the total billable cost for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Contract (Total Cost)" }

    { 47  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (pris i alt);
                           ENU=Billable (Total Price)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare pris i den lokale valuta for sagsopgaven i den periode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in the local currency, the total billable price for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Contract (Total Price)" }

    { 37  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (faktureret kostpris);
                           ENU=Billable (Invoiced Cost)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare omkostning i den lokale valuta for sagsopgaven, der er blevet faktureret i den periode, der er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in the local currency, the total billable cost for the job task that has been invoiced during the time period in the Posting Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Contract (Invoiced Cost)" }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (faktureret pris);
                           ENU=Billable (Invoiced Price)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare pris i den lokale valuta for sagsopgaven, der er blevet faktureret i den periode, der er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in the local currency, the total billable price for the job task that has been invoiced during the time period in the Posting Date Filter field.];
                ApplicationArea=#Jobs;
                SourceExpr="Contract (Invoiced Price)" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbel›b i regnskabsvalutaen som summen af omkostninger fra de sagsplanl‘gningslinjer, der er tilknyttet sagsopgaven.;
                           ENU=Specifies the remaining total cost (LCY) as the sum of costs from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining (Total Cost)" }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbel›b i regnskabsvalutaen som summen af salgspriser fra de sagsplanl‘gningslinjer, der er tilknyttet sagsopgaven. Beregningen forekommer, n†r du har angivet, at der er et forbrugslink mellem sagsposten og sagsplanl‘gningslinjerne.;
                           ENU=Specifies the remaining total price (LCY) as the sum of prices from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.];
                ApplicationArea=#Jobs;
                SourceExpr="Remaining (Total Price)" }

    { 73  ;2   ;Field     ;
                Name=EAC (Total Cost);
                CaptionML=[DAN=EAC (kostbel›b);
                           ENU=EAC (Total Cost)];
                ToolTipML=[DAN=Angiver det samlede kostbel›b i estimatet ved fuldf›relse (EAC) for en sagsopgavelinje. Hvis afkrydsningsfeltet Anvend anvendelseslink p† sagen er markeret, beregnes feltet EAC (Kostbel›b) p† f›lgende m†de:;
                           ENU=Specifies the estimate at completion (EAC) total cost for a job task line. If the Apply Usage Link check box on the job is selected, then the EAC (Total Cost) field is calculated as follows:];
                ApplicationArea=#Jobs;
                SourceExpr=CalcEACTotalCost }

    { 75  ;2   ;Field     ;
                Name=EAC (Total Price);
                CaptionML=[DAN=EAC (salgsbel›b);
                           ENU=EAC (Total Price)];
                ToolTipML=[DAN=Angiver den samlede pris i estimatet ved fuldf›relse (EAC) for en sagsopgavelinje. Hvis afkrydsningsfeltet Anvend anvendelseslink p† sagen er markeret, beregnes feltet EAC (Salgsbel›b) p† f›lgende m†de:;
                           ENU=Specifies the estimate at completion (EAC) total price for a job task line. If the Apply Usage Link check box on the job is selected, then the EAC (Total Price) field is calculated as follows:];
                ApplicationArea=#Jobs;
                SourceExpr=CalcEACTotalPrice }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Jobs;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Jobs;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af de udest†ende ordrer i den lokale valuta for denne sagsopgave. V‘rdien i feltet Udest†ende bel›b (RV) bruges til poster i tabellen K›bslinje med dokumenttypen Ordre til at beregne og opdatere indholdet i dette felt.;
                           ENU=Specifies the sum of outstanding orders, in local currency, for this job task. The value of the Outstanding Amount (LCY) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.];
                ApplicationArea=#Jobs;
                SourceExpr="Outstanding Orders";
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=VAR
                              PurchLine@1000 : Record 39;
                            BEGIN
                              SetPurchLineFilters(PurchLine);
                              PurchLine.SETFILTER("Outstanding Amount (LCY)",'<> 0');
                              PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
                            END;
                             }

    { 1002;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen for varer, der er modtaget, men endnu ikke er blevet faktureret. V‘rdien i feltet Bel›b modt. ufaktureret (RV) bruges til poster i tabellen K›bslinje med dokumenttypen Ordre til at beregne og opdatere indholdet i feltet.;
                           ENU=Specifies the sum for items that have been received but have not yet been invoiced. The value in the Amt. Rcd. Not Invoiced (LCY) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.];
                ApplicationArea=#Jobs;
                SourceExpr="Amt. Rcd. Not Invoiced";
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=VAR
                              PurchLine@1000 : Record 39;
                            BEGIN
                              SetPurchLineFilters(PurchLine);
                              PurchLine.SETFILTER("Amt. Rcd. Not Invoiced (LCY)",'<> 0');
                              PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
                            END;
                             }

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
    VAR
      DescriptionIndent@1001 : Integer INDATASET;
      StyleIsStrong@1000 : Boolean INDATASET;

    [External]
    PROCEDURE SetPurchLineFilters@3(VAR PurchLine@1000 : Record 39);
    BEGIN
      ApplyPurchaseLineFilters(PurchLine);
    END;

    BEGIN
    END.
  }
}

