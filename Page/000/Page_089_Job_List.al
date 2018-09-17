OBJECT Page 89 Job List
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
    CaptionML=[DAN=Sager;
               ENU=Jobs];
    SourceTable=Table167;
    PageType=List;
    CardPageID=Job Card;
    OnInit=BEGIN
             JobSimplificationAvailable := IsJobSimplificationAvailable;
           END;

    OnOpenPage=BEGIN
                 // Contextual Power BI FactBox: filtering available reports, setting context, loading Power BI related user settings
                 CurrPage."Power BI Report FactBox".PAGE.SetNameFilter(CurrPage.CAPTION);
                 CurrPage."Power BI Report FactBox".PAGE.SetContext(CurrPage.OBJECTID(FALSE));
                 PowerBIVisible := SetPowerBIUserConfig.SetUserConfig(PowerBIUserConfiguration,CurrPage.OBJECTID(FALSE));
               END;

    OnAfterGetCurrRecord=BEGIN
                           // Contextual Power BI FactBox: send data to filter the report in the FactBox
                           CurrPage."Power BI Report FactBox".PAGE.SetCurrentListSelection("No.",FALSE);
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Sag;
                                 ENU=&Job];
                      Image=Job }
      { 37      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+T;
                      CaptionML=[DAN=Sagsopgave&linjer;
                                 ENU=Job Task &Lines];
                      ToolTipML=[DAN=Planl�g, hvordan du vil konfigurere dine planl�gningsoplysninger. I dette vindue kan du angive, hvilke opgaver sagen omfatter. N�r du vil p�begynde planl�gningen af en sag eller bogf�re forbrug for en sag, skal du oprette mindst en sagsopgave.;
                                 ENU=Plan how you want to set up your planning information. In this window you can specify the tasks involved in a job. To start planning a job or to post usage for a job, you must set up at least one job task.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1002;
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=TaskList;
                      PromotedCategory=Process }
      { 13      ;2   ;ActionGroup;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      Image=Dimensions }
      { 84      ;3   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=Dimensioner - &enkelt;
                                 ENU=Dimensions-&Single];
                      ToolTipML=[DAN=F� vist eller rediger de enkelte s�t af dimensioner, der er oprettet for den valgte record.;
                                 ENU=View or edit the single set of dimensions that are set up for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(167),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 12      ;3   ;Action    ;
                      AccessByPermission=TableData 348=R;
                      CaptionML=[DAN=Dimensioner - &flere;
                                 ENU=Dimensions-&Multiple];
                      ToolTipML=[DAN=Vis eller rediger dimensionerne for en gruppe af records. Du kan tildele dimensionskoder til transaktioner for at fordele omkostninger og analysere historikken.;
                                 ENU=View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.];
                      ApplicationArea=#Jobs;
                      Image=DimensionSets;
                      OnAction=VAR
                                 Job@1001 : Record 167;
                                 DefaultDimensionsMultiple@1002 : Page 542;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(Job);
                                 DefaultDimensionsMultiple.SetMultiJob(Job);
                                 DefaultDimensionsMultiple.RUNMODAL;
                               END;
                                }
      { 33      ;2   ;Action    ;
                      ShortCutKey=F7;
                      CaptionML=[DAN=&Statistik;
                                 ENU=&Statistics];
                      ToolTipML=[DAN=Vis sagens statistik.;
                                 ENU=View this job's statistics.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1025;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 14      ;2   ;Action    ;
                      Name=SalesInvoicesCreditMemos;
                      CaptionML=[DAN=Salgs&fakturaer/kreditnotaer;
                                 ENU=Sales &Invoices/Credit Memos];
                      ToolTipML=[DAN=Vis salgsfakturaer eller salgskreditnotaer, der er relateret til den valgte sag.;
                                 ENU=View sales invoices or sales credit memos that are related to the selected job.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=GetSourceDoc;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 JobInvoices@1000 : Page 1029;
                               BEGIN
                                 JobInvoices.SetPrJob(Rec);
                                 JobInvoices.RUNMODAL;
                               END;
                                }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Job),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 150     ;1   ;ActionGroup;
                      CaptionML=[DAN=V&IA;
                                 ENU=W&IP];
                      Image=WIP }
      { 153     ;2   ;Action    ;
                      CaptionML=[DAN=&VIA-poster;
                                 ENU=&WIP Entries];
                      ToolTipML=[DAN=Vis poster for den sag, der er bogf�rt som igangv�rende arbejde.;
                                 ENU=View entries for the job that are posted as work in process.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1008;
                      RunPageView=SORTING(Job No.,Job Posting Group,WIP Posting Date)
                                  ORDER(Descending);
                      RunPageLink=Job No.=FIELD(No.);
                      Image=WIPEntries }
      { 154     ;2   ;Action    ;
                      CaptionML=[DAN=VIA-&finansposter;
                                 ENU=WIP &G/L Entries];
                      ToolTipML=[DAN=Vis sagens finansposter for igangv�rende arbejde.;
                                 ENU=View the job's WIP G/L entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1009;
                      RunPageView=SORTING(Job No.)
                                  ORDER(Descending);
                      RunPageLink=Job No.=FIELD(No.);
                      Image=WIPLedger }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      Image=Price }
      { 38      ;2   ;Action    ;
                      CaptionML=[DAN=R&essource;
                                 ENU=&Resource];
                      ToolTipML=[DAN=Vis sagens ressourcepriser.;
                                 ENU=View this job's resource prices.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1011;
                      RunPageLink=Job No.=FIELD(No.);
                      Image=Resource }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      ToolTipML=[DAN=Vis sagens varepriser.;
                                 ENU=View this job's item prices.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1012;
                      RunPageLink=Job No.=FIELD(No.);
                      Image=Item }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=&Finanskonto;
                                 ENU=&G/L Account];
                      ToolTipML=[DAN=Vis sagens finanskontopriser.;
                                 ENU=View this job's G/L account prices.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1013;
                      RunPageLink=Job No.=FIELD(No.);
                      Image=JobPrice }
      { 21      ;1   ;ActionGroup;
                      CaptionML=[DAN=Plan&l�gn.;
                                 ENU=Plan&ning];
                      Image=Planning }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource allo&keret p� sager;
                                 ENU=Resource &Allocated per Job];
                      ToolTipML=[DAN=Vis sagens ressourcetildeling.;
                                 ENU=View this job's resource allocation.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 221;
                      Image=ViewJob }
      { 27      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource&gruppe allokeret p� sager;
                                 ENU=Res. Group All&ocated per Job];
                      ToolTipML=[DAN=Vis sagens ressourcegruppetildeling.;
                                 ENU=View the job's resource group allocation.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 228;
                      Image=ViewJob }
      { 11      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 32      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf�rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageView=SORTING(Job No.,Job Task No.,Entry Type,Posting Date)
                                  ORDER(Descending);
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      Image=CustomerLedger;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;ActionGroup;
                      Name=<Action9>;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      ActionContainerType=NewDocumentItems;
                      Image=Action }
      { 16      ;2   ;Action    ;
                      Name=CopyJob;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Kopier sag;
                                 ENU=&Copy Job];
                      ToolTipML=[DAN=Kopier en sag og dens sagsopgaver, planl�gningslinjer og priser.;
                                 ENU=Copy a job and its job tasks, planning lines, and prices.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CopyFromTask;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CopyJob@1000 : Page 1040;
                               BEGIN
                                 CopyJob.SetFromJob(Rec);
                                 CopyJob.RUNMODAL;
                               END;
                                }
      { 1903691404;2 ;Action    ;
                      CaptionML=[DAN=Opret &salgsfaktura for sag;
                                 ENU=Create Job &Sales Invoice];
                      ToolTipML=[DAN=Brug en k�rsel til at oprette sagens salgsfakturaer for de involverede sagsplanl�gningslinjer.;
                                 ENU=Use a batch job to help you create job sales invoices for the involved job planning lines.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1093;
                      Promoted=Yes;
                      Image=JobSalesInvoice;
                      PromotedCategory=Process }
      { 7       ;2   ;ActionGroup;
                      CaptionML=[DAN=VI&A;
                                 ENU=W&IP];
                      Image=WIP }
      { 5       ;3   ;Action    ;
                      Name=<Action151>;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Beregn VIA;
                                 ENU=&Calculate WIP];
                      ToolTipML=[DAN=Udf�r k�rslen Beregn VIA - finansafstemning.;
                                 ENU=Run the Job Calculate WIP batch job.];
                      ApplicationArea=#Jobs;
                      Image=CalculateWIP;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Job@1002 : Record 167;
                               BEGIN
                                 TESTFIELD("No.");
                                 Job.COPY(Rec);
                                 Job.SETRANGE("No.","No.");
                                 REPORT.RUNMODAL(REPORT::"Job Calculate WIP",TRUE,FALSE,Job);
                               END;
                                }
      { 3       ;3   ;Action    ;
                      Name=<Action152>;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogf�r VIA;
                                 ENU=&Post WIP to G/L];
                      ToolTipML=[DAN=Udf�r k�rslen Bogf�r VIA - finansafstemning.;
                                 ENU=Run the Job Post WIP to G/L batch job.];
                      ApplicationArea=#Jobs;
                      Image=PostOrder;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Job@1001 : Record 167;
                               BEGIN
                                 TESTFIELD("No.");
                                 Job.COPY(Rec);
                                 Job.SETRANGE("No.","No.");
                                 REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L",TRUE,FALSE,Job);
                               END;
                                }
      { 42      ;1   ;ActionGroup;
                      CaptionML=[DAN=Vis;
                                 ENU=Display] }
      { 41      ;2   ;Action    ;
                      Name=ReportFactBoxVisibility;
                      CaptionML=[DAN=Vis/skjul Power BI-rapporter;
                                 ENU=Show/Hide Power BI Reports];
                      ToolTipML=[DAN=V�lg, om faktaboksen Power BI skal v�re synlig eller ej.;
                                 ENU=Select if the Power BI FactBox is visible or not.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Report;
                      OnAction=BEGIN
                                 IF PowerBIVisible THEN
                                   PowerBIVisible := FALSE
                                 ELSE
                                   PowerBIVisible := TRUE;
                                 // save visibility value into the table
                                 CurrPage."Power BI Report FactBox".PAGE.SetFactBoxVisibility(PowerBIVisible);
                               END;
                                }
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903776506;1 ;Action    ;
                      CaptionML=[DAN=Sag - realiseret/budget;
                                 ENU=Job Actual to Budget];
                      ToolTipML=[DAN=Sammenlign de budgetterede og faktiske forbrugsbel�b for valgte sager. Alle linjer i den valgte sag viser antal, samlede omkostning og linjebel�b.;
                                 ENU=Compare budgeted and usage amounts for selected jobs. All lines of the selected job show quantity, total cost, and line amount.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1009;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901542506;1 ;Action    ;
                      CaptionML=[DAN=Sagsanalyse;
                                 ENU=Job Analysis];
                      ToolTipML=[DAN=Analys�r sagen, f.eks. de budgetterede priser, forbrugspriser og kontraktpriser, og sammenlign derefter de tre s�t priser.;
                                 ENU=Analyze the job, such as the budgeted prices, usage prices, and contract prices, and then compares the three sets of prices.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1008;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902943106;1 ;Action    ;
                      CaptionML=[DAN=Sag - planl�gningslinjer;
                                 ENU=Job - Planning Lines];
                      ToolTipML=[DAN=Vis alle planl�gningslinjer for sagen. Du kan bruge dette vindue til at planl�gge, hvilke varer, ressourcer og finansudgifter du forventer at bruge p� en sag (budget), eller du kan angive det faktiske bel�b, som du har aftalt, at debitoren skal betale for sagen (fakturerbar).;
                                 ENU=View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1006;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903186006;1 ;Action    ;
                      CaptionML=[DAN=Sag - foresl�et fakturering;
                                 ENU=Job - Suggested Billing];
                      ToolTipML=[DAN=Vis en liste over alle sager, grupperet efter debitor, hvor meget debitoren allerede har faktureret, og hvor meget der mangler at blive faktureret, dvs. den foresl�ede fakturering.;
                                 ENU=View a list of all jobs, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1011;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1900510006;1 ;Action    ;
                      CaptionML=[DAN=Sager pr. debitor;
                                 ENU=Jobs per Customer];
                      ToolTipML=[DAN=K�r rapporten Sager pr. debitor.;
                                 ENU=Run the Jobs per Customer report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1012;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1905887906;1 ;Action    ;
                      CaptionML=[DAN=Varer pr. sag;
                                 ENU=Items per Job];
                      ToolTipML=[DAN=Vis, hvilke varer, der bruges i en bestemt sag.;
                                 ENU=View which items are used for a specific job.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1013;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1906922906;1 ;Action    ;
                      CaptionML=[DAN=Sager pr. vare;
                                 ENU=Jobs per Item];
                      ToolTipML=[DAN=K�r rapporten Sager pr. vare.;
                                 ENU=Run the Jobs per item report.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1014;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 26      ;1   ;Action    ;
                      Name=Report Job Quote;
                      CaptionML=[DAN=Vis eksempel p� antal i tilbud;
                                 ENU=Preview Job Quote];
                      ToolTipML=[DAN=�bn rapporten for antal i tilbud.;
                                 ENU=Open the Job Quote report.];
                      ApplicationArea=#Jobs;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 Job@1000 : Record 167;
                               BEGIN
                                 Job.SETCURRENTKEY("No.");
                                 Job.SETFILTER("No.","No.");
                                 REPORT.RUN(REPORT::"Job Quote",TRUE,FALSE,Job);
                               END;
                                }
      { 28      ;1   ;Action    ;
                      Name=Send Job Quote;
                      CaptionML=[DAN=Send antal i tilbud;
                                 ENU=Send Job Quote];
                      ToolTipML=[DAN=Send antallet i tilbuddet til debitoren. Du kan �ndre, hvordan bilaget sendes, i det viste vindue.;
                                 ENU=Send the job quote to the customer. You can change the way that the document is sent in the window that appears.];
                      ApplicationArea=#Jobs;
                      Image=SendTo;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Jobs-Send",Rec);
                               END;
                                }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=�konomistyring;
                                 ENU=Financial Management];
                      Image=Report }
      { 1907574906;2 ;Action    ;
                      CaptionML=[DAN=VIA - finansafstemning;
                                 ENU=Job WIP to G/L];
                      ToolTipML=[DAN=Vis v�rdien af igangv�rende arbejde i de sager, som du v�lger, sammenlignet med de bel�b, der er bogf�rt i finansbogholderiet.;
                                 ENU=View the value of work in process on the jobs that you select compared to the amount that has been posted in the general ledger.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1010;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 23      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=Report }
      { 1905285006;2 ;Action    ;
                      CaptionML=[DAN=Sag - kontokort;
                                 ENU=Jobs - Transaction Detail];
                      ToolTipML=[DAN=Vis alle de bogf�ringer med poster for en bestemt sag i en n�rmere angivet periode, som er blevet debiteret en bestemt sag. For hver sag samment�lles salgsposter og forbrugsposter hver for sig.;
                                 ENU=View all postings with entries for a selected job for a selected period, which have been charged to a certain job. At the end of each job list, the amounts are totaled separately for the Sales and Usage entry types.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1007;
                      Promoted=No;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901294206;2 ;Action    ;
                      CaptionML=[DAN=Sagsjournal;
                                 ENU=Job Register];
                      ToolTipML=[DAN=Vis �n eller flere udvalgte sagsjournaler. Ved at angive et filter kan du udv�lge de journalposter, du vil se. Hvis du har ikke har angivet noget filter, kan rapporten v�re upraktisk at bruge p� grund af den store m�ngde oplysninger. P� sagskladdetypen kan du angive, at rapporten skal udskrives, n�r du bogf�rer.;
                                 ENU=View one or more selected job registers. By using a filter, you can select only those register entries that you want to see. If you do not set a filter, the report can be impractical because it can contain a large amount of information. On the job journal template, you can indicate that you want the report to print when you post.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 1015;
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
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af sagen.;
                           ENU=Specifies a short description of the job.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den debitor, som betaler for sagen.;
                           ENU=Specifies the number of the customer who pays for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Customer No." }

    { 35  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for det aktuelle job. Du kan �ndre status for sagen efterh�nden som den skrider frem. Der kan laves efterberegninger af afsluttede sager.;
                           ENU=Specifies a status for the current job. You can change the status for the job as it progresses. Final calculations can be made on completed jobs.];
                ApplicationArea=#Jobs;
                SourceExpr=Status }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den person, der er ansvarlig for sagen. Du kan v�lge et navn fra listen over ressourcer i vinduet Ressourceliste. Navnet er kopieret fra feltet Nr. i tabellen Ressource. Du kan v�lge feltet for at f� vist en liste over ressourcer.;
                           ENU=Specifies the name of the person responsible for the job. You can select a name from the list of resources available in the Resource List window. The name is copied from the No. field in the Resource table. You can choose the field to see a list of resources.];
                ApplicationArea=#Jobs;
                SourceExpr="Person Responsible";
                Visible=FALSE }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den n�ste fakturadato for sagen.;
                           ENU=Specifies the next invoice date for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Next Invoice Date";
                Visible=FALSE }

    { 19  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en sagsbogf�ringsgruppekode for en sag. V�lg feltet for at f� vist de tilg�ngelige koder.;
                           ENU=Specifies a job posting group code for a job. To see the available codes, choose the field.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Posting Group";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det ekstra navn til sagen. Feltet bruges til s�gninger.;
                           ENU=Specifies the additional name for the job. The field is used for searching purposes.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description" }

    { 18  ;2   ;Field     ;
                Name=% of Overdue Planning Lines;
                CaptionML=[DAN=% af overskredne planl�gningslinjer;
                           ENU=% of Overdue Planning Lines];
                ToolTipML=[DAN=Angiver procentdelen af planl�gningslinjer, som er forfaldne for denne sag.;
                           ENU=Specifies the percent of planning lines that are overdue for this job.];
                ApplicationArea=#Jobs;
                SourceExpr=PercentOverdue;
                Visible=FALSE;
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                Name=% Completed;
                CaptionML=[DAN=% fuldf�rt;
                           ENU=% Completed];
                ToolTipML=[DAN=Angiver fuldf�relsesprocentdelen for denne sag.;
                           ENU=Specifies the completion percentage for this job.];
                ApplicationArea=#Jobs;
                SourceExpr=PercentCompleted;
                Visible=FALSE;
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                Name=% Invoiced;
                CaptionML=[DAN=% faktureret;
                           ENU=% Invoiced];
                ToolTipML=[DAN=Angiver den fakturerede procentdel for denne sag.;
                           ENU=Specifies the invoiced percentage for this job.];
                ApplicationArea=#Jobs;
                SourceExpr=PercentInvoiced;
                Visible=FALSE;
                Editable=FALSE }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den person, der er tildelt som chef for denne sag.;
                           ENU=Specifies the person assigned as the manager for this job.];
                ApplicationArea=#Jobs;
                SourceExpr="Project Manager";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 36  ;1   ;Part      ;
                Name=Power BI Report FactBox;
                CaptionML=[DAN=Power BI-rapporter;
                           ENU=Power BI Reports];
                ApplicationArea=#Basic,#Suite;
                PagePartID=Page6306;
                Visible=PowerBIVisible;
                PartType=Page }

    { 1907234507;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9081;
                Visible=FALSE;
                PartType=Page }

    { 1902018507;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=FALSE;
                PartType=Page }

    { 1905650007;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page9099;
                Visible=TRUE;
                PartType=Page }

    { 25  ;1   ;Part      ;
                CaptionML=[DAN=Sagsdetaljer;
                           ENU=Job Details];
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.);
                PagePartID=Page1030;
                Visible=JobSimplificationAvailable;
                PartType=Page }

    { 1900383207;1;Part   ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 1905767507;1;Part   ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      PowerBIUserConfiguration@1001 : Record 6304;
      SetPowerBIUserConfig@1002 : Codeunit 6305;
      PowerBIVisible@1003 : Boolean;
      JobSimplificationAvailable@1000 : Boolean;

    BEGIN
    END.
  }
}

