OBJECT Page 1001 Job Task Lines Subform
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Underform til sagsopgavelinjer;
               ENU=Job Task Lines Subform];
    SaveValues=Yes;
    SourceTable=Table1001;
    DataCaptionFields=Job No.;
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       DescriptionIndent := Indentation;
                       StyleIsStrong := "Job Task Type" <> "Job Task Type"::Posting;
                     END;

    OnNewRecord=BEGIN
                  ClearTempDim;
                END;

    ActionList=ACTIONS
    {
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 6       ;1   ;ActionGroup;
                      CaptionML=[DAN=Linje;
                                 ENU=Line] }
      { 14      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Sag;
                                 ENU=&Job];
                      Image=Job }
      { 7       ;3   ;Action    ;
                      Name=JobPlanningLines;
                      ShortCutKey=Shift+Ctrl+P;
                      CaptionML=[DAN=Sags&planl‘gningslinjer;
                                 ENU=Job &Planning Lines];
                      ToolTipML=[DAN=Vis alle planl‘gningslinjer for sagen. Du kan bruge dette vindue til at planl‘gge, hvilke varer, ressourcer og finansudgifter du forventer at bruge p† en sag (budget), eller du kan angive det faktiske bel›b, som du har aftalt, at debitoren skal betale for sagen (fakturerbar).;
                                 ENU=View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).];
                      ApplicationArea=#Jobs;
                      Image=JobLines;
                      Scope=Repeater;
                      OnAction=VAR
                                 JobPlanningLine@1001 : Record 1003;
                                 JobPlanningLines@1000 : Page 1007;
                               BEGIN
                                 TESTFIELD("Job No.");
                                 JobPlanningLine.FILTERGROUP(2);
                                 JobPlanningLine.SETRANGE("Job No.","Job No.");
                                 JobPlanningLine.SETRANGE("Job Task No.","Job Task No.");
                                 JobPlanningLine.FILTERGROUP(0);
                                 JobPlanningLines.SETTABLEVIEW(JobPlanningLine);
                                 JobPlanningLines.EDITABLE := TRUE;
                                 JobPlanningLines.RUN;
                               END;
                                }
      { 18      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      Image=Dimensions }
      { 16      ;3   ;Action    ;
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
      { 10      ;3   ;Action    ;
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
      { 31      ;2   ;ActionGroup;
                      CaptionML=[DAN=Dokumenter;
                                 ENU=Documents];
                      Image=Invoice }
      { 15      ;3   ;Action    ;
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
      { 19      ;3   ;Action    ;
                      Name=SalesInvoicesCreditMemos;
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
      { 20      ;2   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 21      ;3   ;Action    ;
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
      { 4       ;2   ;ActionGroup;
                      CaptionML=[DAN=F&unktioner;
                                 ENU=F&unctions];
                      Image=Action }
      { 17      ;3   ;Action    ;
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
      { 22      ;3   ;Action    ;
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
      { 13      ;3   ;Action    ;
                      Name=<Action7>;
                      CaptionML=[DAN=I&ndryk sagsopgaver;
                                 ENU=I&ndent Job Tasks];
                      ToolTipML=[DAN=Flyt de valgte linjer i en position for at vise, at opgaverne er underkategorier for andre opgaver. Sagsopgaver, der er sammentalt, ligger mellem et par tilsvarende Fra sum- og Til sum-sagsopgaver.;
                                 ENU=Move the selected lines in one position to show that the tasks are subcategories of other tasks. Job tasks that are totaled are the ones that lie between one pair of corresponding Begin-Total and End-Total job tasks.];
                      ApplicationArea=#Jobs;
                      RunObject=Codeunit 1003;
                      Image=Indent }
      { 23      ;3   ;ActionGroup;
                      CaptionML=[DAN=K&opi‚r;
                                 ENU=&Copy];
                      ActionContainerType=NewDocumentItems;
                      Image=Copy }
      { 32      ;4   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopi‚r sagsplanl‘gningslinjer &fra...;
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
      { 33      ;4   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopi‚r sagsplanl‘gningslinjer &til...;
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
      { 25      ;3   ;ActionGroup;
                      Name=<Action13>;
                      CaptionML=[DAN=V&IA;
                                 ENU=W&IP];
                      ActionContainerType=NewDocumentItems;
                      Image=WIP }
      { 3       ;4   ;Action    ;
                      Name=<Action48>;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Beregn VIA;
                                 ENU=&Calculate WIP];
                      ToolTipML=[DAN=Udf›r k›rslen Beregn VIA.;
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
      { 11      ;4   ;Action    ;
                      Name=<Action49>;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogf›r VIA;
                                 ENU=&Post WIP to G/L];
                      ToolTipML=[DAN=Udf›r k›rslen Bogf›r VIA.;
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
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Job Task No.";
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af sagsopgaven. Du kan indtaste alt, der giver mening i beskrivelsen af opgaven. Beskrivelsen kopieres og bruges i beskrivelser p† sagsplanl‘gningslinjen.;
                           ENU=Specifies a description of the job task. You can enter anything that is meaningful in describing the task. The description is copied and used in descriptions on the job planning line.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr=Description;
                Style=Strong;
                StyleExpr=StyleIsStrong }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontoens form†l. Nyoprettede konti f†r automatisk tildelt kontotypen Bogf›ring, men det kan du ‘ndre. V‘lg feltet for at v‘lge ‚n af f›lgende fem indstillinger:;
                           ENU=Specifies the purpose of the account. Newly created accounts are automatically assigned the Posting account type, but you can change this. Choose the field to select one of the following five options:];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Job Task Type" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver et interval eller en liste over sagsopgavenumre.;
                           ENU=Specifies an interval or a list of job task numbers.];
                ApplicationArea=#Suite;
                SourceExpr=Totaling;
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagsbogf›ringsgruppen for opgaven.;
                           ENU=Specifies the job posting group of the task.];
                ApplicationArea=#Suite;
                SourceExpr="Job Posting Group";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de sagsopgaver, du vil gruppere ved beregning af Igangv‘rende arbejde (VIA) og Registrering.;
                           ENU=Specifies the job tasks you want to group together when calculating Work In Process (WIP) and Recognition.];
                ApplicationArea=#Suite;
                SourceExpr="WIP-Total";
                Visible=FALSE }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† beregningsmetoden Igangv‘rende arbejde, der er tilknyttet en sag. V‘rdien i dette felt kommer fra den VIA-metode, der er angivet p† jobkortet.;
                           ENU=Specifies the name of the Work in Process calculation method that is associated with a job. The value in this field comes from the WIP method specified on the job card.];
                ApplicationArea=#Suite;
                SourceExpr="WIP Method";
                Visible=FALSE }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for sagsopgaven. Datoen er baseret p† datoen i linjen for den relaterede opgaveplanl‘gning.;
                           ENU=Specifies the start date for the job task. The date is based on the date on the related job planning line.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Start Date" }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for sagsopgaven. Datoen er baseret p† datoen i linjen for den relaterede opgaveplanl‘gning.;
                           ENU=Specifies the end date for the job task. The date is based on the date on the related job planning line.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="End Date" }

    { 40  ;2   ;Field     ;
                CaptionML=[DAN=Budget (kostbel›b);
                           ENU=Budget (Total Cost)];
                ToolTipML=[DAN=Angiver den samlede budgetterede omkostning i den lokale valuta for sagsopgaven for den tidsperiode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in the local currency, the total budgeted cost for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Schedule (Total Cost)" }

    { 42  ;2   ;Field     ;
                CaptionML=[DAN=Budget (salgsbel›b);
                           ENU=Budget (Total Price)];
                ToolTipML=[DAN=Angiver den samlede budgetterede pris i den lokale valuta for sagsopgaven for den tidsperiode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in local currency, the total budgeted price for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Suite;
                SourceExpr="Schedule (Total Price)";
                Visible=FALSE }

    { 44  ;2   ;Field     ;
                CaptionML=[DAN=Faktisk (kostbel›b);
                           ENU=Actual (Total Cost)];
                ToolTipML=[DAN=Angiver det samlede kostbel›b i den lokale valuta for de brugte varer, ressourcer og finansudgifter, der er bogf›rt for sagsopgaven i den tidsperiode, som er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in local currency, the total cost of the usage of items, resources and general ledger expenses posted on the job task during the time period in the Posting Date Filter field.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Usage (Total Cost)" }

    { 8   ;2   ;Field     ;
                CaptionML=[DAN=Faktisk (salgsbel›b);
                           ENU=Actual (Total Price)];
                ToolTipML=[DAN=Angiver den samlede pris i den lokale valuta for forbruget af varer, ressourcer og finansudgifter, der er bogf›rt for sagsopgaven i den periode, som er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in the local currency, the total price of the usage of items, resources and general ledger expenses posted on the job task during the time period in the Posting Date Filter field.];
                ApplicationArea=#Suite;
                SourceExpr="Usage (Total Price)";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (kostbel›b i alt);
                           ENU=Billable (Total Cost)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare omkostning i den lokale valuta for sagsopgaven i den periode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in local currency, the total billable cost for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Suite;
                SourceExpr="Contract (Total Cost)";
                Visible=FALSE }

    { 47  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (pris i alt);
                           ENU=Billable (Total Price)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare pris i den lokale valuta for sagsopgaven i den periode, der er angivet i feltet Planl‘gningsdatofilter.;
                           ENU=Specifies, in the local currency, the total billable price for the job task during the time period in the Planning Date Filter field.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Contract (Total Price)" }

    { 37  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (faktureret kostpris);
                           ENU=Billable (Invoiced Cost)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare omkostning i den lokale valuta for sagsopgaven, der er blevet faktureret i den periode, der er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in the local currency, the total billable cost for the job task that has been invoiced during the time period in the Posting Date Filter field.];
                ApplicationArea=#Suite;
                SourceExpr="Contract (Invoiced Cost)";
                Visible=FALSE }

    { 51  ;2   ;Field     ;
                CaptionML=[DAN=Fakturerbar (faktureret pris);
                           ENU=Billable (Invoiced Price)];
                ToolTipML=[DAN=Angiver den samlede fakturerbare pris i den lokale valuta for sagsopgaven, der er blevet faktureret i den periode, der er angivet i feltet Bogf›ringsdatofilter.;
                           ENU=Specifies, in the local currency, the total billable price for the job task that has been invoiced during the time period in the Posting Date Filter field.];
                ApplicationArea=#Basic,#Suite,#Jobs;
                SourceExpr="Contract (Invoiced Price)" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbel›b i regnskabsvalutaen som summen af omkostninger fra de sagsplanl‘gningslinjer, der er tilknyttet sagsopgaven.;
                           ENU=Specifies the remaining total cost (LCY) as the sum of costs from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.];
                ApplicationArea=#Suite;
                SourceExpr="Remaining (Total Cost)";
                Visible=FALSE }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det resterende kostbel›b i regnskabsvalutaen som summen af salgspriser fra de sagsplanl‘gningslinjer, der er tilknyttet sagsopgaven. Beregningen forekommer, n†r du har angivet, at der er et forbrugslink mellem sagsposten og sagsplanl‘gningslinjerne.;
                           ENU=Specifies the remaining total price (LCY) as the sum of prices from job planning lines associated with the job task. The calculation occurs when you have specified that there is a usage link between the job ledger and the job planning lines.];
                ApplicationArea=#Suite;
                SourceExpr="Remaining (Total Price)";
                Visible=FALSE }

    { 73  ;2   ;Field     ;
                Name=EAC (Total Cost);
                CaptionML=[DAN=EAC (kostbel›b);
                           ENU=EAC (Total Cost)];
                ToolTipML=[DAN=Angiver det samlede kostbel›b i estimatet ved fuldf›relse (EAC) for en sagsopgavelinje. Hvis afkrydsningsfeltet Anvend anvendelseslink p† sagen er markeret, beregnes feltet EAC (Kostbel›b) p† f›lgende m†de:;
                           ENU=Specifies the estimate at completion (EAC) total cost for a job task line. If the Apply Usage Link check box on the job is selected, then the EAC (Total Cost) field is calculated as follows:];
                ApplicationArea=#Suite;
                SourceExpr=CalcEACTotalCost;
                Visible=FALSE }

    { 75  ;2   ;Field     ;
                Name=EAC (Total Price);
                CaptionML=[DAN=EAC (salgsbel›b);
                           ENU=EAC (Total Price)];
                ToolTipML=[DAN=Angiver den samlede pris i estimatet ved fuldf›relse (EAC) for en sagsopgavelinje. Hvis afkrydsningsfeltet Anvend anvendelseslink p† sagen er markeret, beregnes feltet EAC (Salgsbel›b) p† f›lgende m†de:;
                           ENU=Specifies the estimate at completion (EAC) total price for a job task line. If the Apply Usage Link check box on the job is selected, then the EAC (Total Price) field is calculated as follows:];
                ApplicationArea=#Suite;
                SourceExpr=CalcEACTotalPrice;
                Visible=FALSE }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 1 Code";
                Visible=FALSE }

    { 69  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den globale dimension, der er knyttet til recorden eller posten med henblik p† analyse. To globale dimensioner, typiske for virksomhedens vigtigste aktiviteter, er tilg‘ngelige p† alle kort, bilag, rapporter og lister.;
                           ENU=Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company's most important activities, are available on all cards, documents, reports, and lists.];
                ApplicationArea=#Suite;
                SourceExpr="Global Dimension 2 Code";
                Visible=FALSE }

    { 1000;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen af de udest†ende ordrer i den lokale valuta for denne sagsopgave. V‘rdien i feltet Udest†ende bel›b (RV) bruges til poster i tabellen K›bslinje med dokumenttypen Ordre til at beregne og opdatere indholdet i dette felt.;
                           ENU=Specifies the sum of outstanding orders, in local currency, for this job task. The value of the Outstanding Amount (LCY) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.];
                ApplicationArea=#Suite;
                SourceExpr="Outstanding Orders";
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=VAR
                              PurchLine@1000 : Record 39;
                            BEGIN
                              ApplyPurchaseLineFilters(PurchLine);
                              PurchLine.SETFILTER("Outstanding Amount (LCY)",'<> 0');
                              PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
                            END;
                             }

    { 1002;2   ;Field     ;
                ToolTipML=[DAN=Angiver summen for varer, der er modtaget, men endnu ikke er blevet faktureret. V‘rdien i feltet Bel›b modt. ufaktureret (RV) bruges til poster i tabellen K›bslinje med dokumenttypen Ordre til at beregne og opdatere indholdet i feltet.;
                           ENU=Specifies the sum for items that have been received but have not yet been invoiced. The value in the Amt. Rcd. Not Invoiced (LCY) field is used for entries in the Purchase Line table of document type Order to calculate and update the contents of this field.];
                ApplicationArea=#Suite;
                SourceExpr="Amt. Rcd. Not Invoiced";
                Visible=FALSE;
                Editable=FALSE;
                OnDrillDown=VAR
                              PurchLine@1000 : Record 39;
                            BEGIN
                              ApplyPurchaseLineFilters(PurchLine);
                              PurchLine.SETFILTER("Amt. Rcd. Not Invoiced (LCY)",'<> 0');
                              PAGE.RUNMODAL(PAGE::"Purchase Lines",PurchLine);
                            END;
                             }

  }
  CODE
  {
    VAR
      DescriptionIndent@1001 : Integer INDATASET;
      StyleIsStrong@1000 : Boolean INDATASET;

    BEGIN
    END.
  }
}

