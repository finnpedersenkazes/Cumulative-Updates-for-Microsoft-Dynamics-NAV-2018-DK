OBJECT Page 88 Job Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Jobkort;
               ENU=Job Card];
    SourceTable=Table167;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,RapportÇr,Priser;
                                ENU=New,Process,Report,Prices];
    OnInit=BEGIN
             JobSimplificationAvailable := IsJobSimplificationAvailable;
           END;

    OnOpenPage=BEGIN
                 SetNoFieldVisible;
               END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 58      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Sag;
                                 ENU=&Job];
                      Image=Job }
      { 88      ;2   ;Action    ;
                      Name=JobPlanningLines;
                      ShortCutKey=Shift+Ctrl+P;
                      CaptionML=[DAN=Sags&planlëgningslinjer;
                                 ENU=Job &Planning Lines];
                      ToolTipML=[DAN=Vis alle planlëgningslinjer for sagen. Du kan bruge dette vindue til at planlëgge, hvilke varer, ressourcer og finansudgifter du forventer at bruge pÜ en sag (budget), eller du kan angive det faktiske belõb, som du har aftalt, at debitoren skal betale for sagen (fakturerbar).;
                                 ENU=View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (Budget) or you can specify what you actually agreed with your customer that he should pay for the job (Billable).];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=JobLines;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 JobPlanningLine@1001 : Record 1003;
                                 JobPlanningLines@1000 : Page 1007;
                               BEGIN
                                 TESTFIELD("No.");
                                 JobPlanningLine.FILTERGROUP(2);
                                 JobPlanningLine.SETRANGE("Job No.","No.");
                                 JobPlanningLine.FILTERGROUP(0);
                                 JobPlanningLines.SetJobTaskNoVisible(TRUE);
                                 JobPlanningLines.SETTABLEVIEW(JobPlanningLine);
                                 JobPlanningLines.EDITABLE := TRUE;
                                 JobPlanningLines.RUN;
                               END;
                                }
      { 84      ;2   ;Action    ;
                      ShortCutKey=Shift+Ctrl+D;
                      CaptionML=[DAN=&Dimensioner;
                                 ENU=&Dimensions];
                      ToolTipML=[DAN=FÜ vist eller rediger dimensioner som f.eks. omrÜde, projekt eller afdeling, som du kan tildele til kladdelinjer for at fordele omkostninger og analysere transaktionshistorik.;
                                 ENU=View or edit dimensions, such as area, project, or department, that you can assign to journal lines to distribute costs and analyze transaction history.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 540;
                      RunPageLink=Table ID=CONST(167),
                                  No.=FIELD(No.);
                      Image=Dimensions }
      { 61      ;2   ;Action    ;
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
      { 64      ;2   ;Separator  }
      { 62      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 124;
                      RunPageLink=Table Name=CONST(Job),
                                  No.=FIELD(No.);
                      Image=ViewComments }
      { 66      ;2   ;Action    ;
                      CaptionML=[DAN=&Online Map;
                                 ENU=&Online Map];
                      ToolTipML=[DAN=Vis onlinekort for de adresser, der er tildelt denne sag.;
                                 ENU=View online map for addresses assigned to this job.];
                      ApplicationArea=#Jobs;
                      Image=Map;
                      OnAction=BEGIN
                                 DisplayMap;
                               END;
                                }
      { 81      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&IA;
                                 ENU=W&IP];
                      Image=WIP }
      { 85      ;2   ;Action    ;
                      CaptionML=[DAN=&VIA-poster;
                                 ENU=&WIP Entries];
                      ToolTipML=[DAN=Vis poster for den sag, der er bogfõrt som igangvërende arbejde.;
                                 ENU=View entries for the job that are posted as work in process.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1008;
                      RunPageView=SORTING(Job No.,Job Posting Group,WIP Posting Date)
                                  ORDER(Descending);
                      RunPageLink=Job No.=FIELD(No.);
                      Image=WIPEntries }
      { 86      ;2   ;Action    ;
                      CaptionML=[DAN=VIA-&finansposter;
                                 ENU=WIP &G/L Entries];
                      ToolTipML=[DAN=Vis sagens finansposter for igangvërende arbejde.;
                                 ENU=View the job's WIP G/L entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1009;
                      RunPageView=SORTING(Job No.)
                                  ORDER(Descending);
                      RunPageLink=Job No.=FIELD(No.);
                      Image=WIPLedger }
      { 54      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Priser;
                                 ENU=&Prices];
                      Image=Price }
      { 93      ;2   ;Action    ;
                      CaptionML=[DAN=R&essource;
                                 ENU=&Resource];
                      ToolTipML=[DAN=Vis sagens ressourcepriser.;
                                 ENU=View this job's resource prices.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1011;
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Resource;
                      PromotedCategory=Category4 }
      { 94      ;2   ;Action    ;
                      CaptionML=[DAN=V&are;
                                 ENU=&Item];
                      ToolTipML=[DAN=Vis sagens varepriser.;
                                 ENU=View this job's item prices.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1012;
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Item;
                      PromotedCategory=Category4 }
      { 95      ;2   ;Action    ;
                      CaptionML=[DAN=&Finanskonto;
                                 ENU=&G/L Account];
                      ToolTipML=[DAN=Vis sagens finanskontopriser.;
                                 ENU=View this job's G/L account prices.];
                      ApplicationArea=#Suite;
                      RunObject=Page 1013;
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=JobPrice;
                      PromotedCategory=Category4 }
      { 53      ;1   ;ActionGroup;
                      CaptionML=[DAN=Plan&lëgn.;
                                 ENU=Plan&ning];
                      Image=Planning }
      { 65      ;2   ;Action    ;
                      CaptionML=[DAN=Ressource allo&keret pÜ sager;
                                 ENU=Resource &Allocated per Job];
                      ToolTipML=[DAN=Vis sagens ressourcetildeling.;
                                 ENU=View this job's resource allocation.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 221;
                      Image=ViewJob }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=Ress.grp. for&delt pr. sag;
                                 ENU=Res. Gr. All&ocated per Job];
                      ToolTipML=[DAN=Vis sagens ressourcegruppetildeling.;
                                 ENU=View the job's resource group allocation.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 228;
                      Image=ResourceGroup }
      { 40      ;1   ;ActionGroup;
                      CaptionML=[DAN=Oversigt;
                                 ENU=History];
                      Image=History }
      { 60      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Poster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogfõrt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageView=SORTING(Job No.,Job Task No.,Entry Type,Posting Date)
                                  ORDER(Descending);
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      Image=JobLedger;
                      PromotedCategory=Process }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Kopier;
                                 ENU=&Copy];
                      ActionContainerType=NewDocumentItems;
                      Image=Copy }
      { 31      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier sagsopgaver &fra...;
                                 ENU=Copy Job Tasks &from...];
                      ToolTipML=[DAN=èbn siden Kopier sagsopgaver.;
                                 ENU=Open the Copy Job Tasks page.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CopyToTask;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CopyJobTasks@1000 : Page 1041;
                               BEGIN
                                 CopyJobTasks.SetToJob(Rec);
                                 CopyJobTasks.RUNMODAL;
                               END;
                                }
      { 27      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Kopier sagsopgaver &til...;
                                 ENU=Copy Job Tasks &to...];
                      ToolTipML=[DAN=èbn siden Kopier sager til.;
                                 ENU=Open the Copy Jobs To page.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CopyFromTask;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 CopyJobTasks@1000 : Page 1041;
                               BEGIN
                                 CopyJobTasks.SetFromJob(Rec);
                                 CopyJobTasks.RUNMODAL;
                               END;
                                }
      { 26      ;1   ;ActionGroup;
                      CaptionML=[DAN=VI&A;
                                 ENU=W&IP];
                      Image=WIP }
      { 25      ;2   ;Action    ;
                      Name=<Action82>;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Beregn VIA;
                                 ENU=&Calculate WIP];
                      ToolTipML=[DAN=Udfõr kõrslen Beregn VIA - finansafstemning.;
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
      { 24      ;2   ;Action    ;
                      Name=<Action83>;
                      ShortCutKey=F9;
                      Ellipsis=Yes;
                      CaptionML=[DAN=&Bogfõr VIA;
                                 ENU=&Post WIP to G/L];
                      ToolTipML=[DAN=Udfõr kõrslen Bogfõr VIA - finansafstemning.;
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
      { 1900000006;0 ;ActionContainer;
                      ActionContainerType=Reports }
      { 1903776506;1 ;Action    ;
                      CaptionML=[DAN=Sag - realiseret/budget;
                                 ENU=Job Actual to Budget];
                      ToolTipML=[DAN=Sammenlign de budgetterede og faktiske forbrugsbelõb for valgte sager. Alle linjer i den valgte sag viser antal, samlede omkostning og linjebelõb.;
                                 ENU=Compare budgeted and usage amounts for selected jobs. All lines of the selected job show quantity, total cost, and line amount.];
                      ApplicationArea=#Suite;
                      RunObject=Report 1009;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1901542506;1 ;Action    ;
                      CaptionML=[DAN=Sagsanalyse;
                                 ENU=Job Analysis];
                      ToolTipML=[DAN=AnalysÇr sagen, f.eks. de budgetterede priser, forbrugspriser og fakturerbare priser, og sammenlign derefter de tre sët priser.;
                                 ENU=Analyze the job, such as the budgeted prices, usage prices, and billable prices, and then compares the three sets of prices.];
                      ApplicationArea=#Suite;
                      RunObject=Report 1008;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1902943106;1 ;Action    ;
                      CaptionML=[DAN=Sag - planlëgningslinjer;
                                 ENU=Job - Planning Lines];
                      ToolTipML=[DAN=Vis alle planlëgningslinjer for sagen. Du kan bruge dette vindue til at planlëgge, hvilke varer, ressourcer og finansudgifter du forventer at bruge pÜ en sag (budget), eller du kan angive det faktiske belõb, som du har aftalt, at debitoren skal betale for sagen (fakturerbar).;
                                 ENU=View all planning lines for the job. You use this window to plan what items, resources, and general ledger expenses that you expect to use on a job (budget) or you can specify what you actually agreed with your customer that he should pay for the job (billable).];
                      ApplicationArea=#Suite;
                      RunObject=Report 1006;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 1903186006;1 ;Action    ;
                      CaptionML=[DAN=Sag - foreslÜet fakturering;
                                 ENU=Job - Suggested Billing];
                      ToolTipML=[DAN=Vis en liste over alle sager, grupperet efter debitor, hvor meget debitoren allerede har faktureret, og hvor meget der mangler at blive faktureret, dvs. den foreslÜede fakturering.;
                                 ENU=View a list of all jobs, grouped by customer, how much the customer has already been invoiced, and how much remains to be invoiced, that is, the suggested billing.];
                      ApplicationArea=#Suite;
                      RunObject=Report 1011;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report }
      { 46      ;1   ;Action    ;
                      Name=Report Job Quote;
                      CaptionML=[DAN=Vise eksempel pÜ antal i tilbud;
                                 ENU=Preview Job Quote];
                      ToolTipML=[DAN=èbn rapporten for antal i tilbud.;
                                 ENU=Open the Job Quote report.];
                      ApplicationArea=#Suite;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 Job@1001 : Record 167;
                               BEGIN
                                 Job.SETCURRENTKEY("No.");
                                 Job.SETFILTER("No.","No.");
                                 REPORT.RUN(REPORT::"Job Quote",TRUE,FALSE,Job);
                               END;
                                }
      { 48      ;1   ;Action    ;
                      Name=Send Job Quote;
                      CaptionML=[DAN=Sende antal i tilbud;
                                 ENU=Send Job Quote];
                      ToolTipML=[DAN=Send antallet i tilbuddet til debitoren. Du kan ëndre, hvordan bilaget sendes, i det viste vindue.;
                                 ENU=Send the job quote to the customer. You can change the way that the document is sent in the window that appears.];
                      ApplicationArea=#Suite;
                      Image=SendTo;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 CODEUNIT.RUN(CODEUNIT::"Jobs-Send",Rec);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                CaptionML=[DAN=Generelt;
                           ENU=General] }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#All;
                SourceExpr="No.";
                Importance=Additional;
                Visible=NoFieldVisible;
                OnAssistEdit=BEGIN
                               IF AssistEdit(xRec) THEN
                                 CurrPage.UPDATE;
                             END;
                              }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af sagen.;
                           ENU=Specifies a short description of the job.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den debitor, som betaler for sagen.;
                           ENU=Specifies the number of the customer who pays for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Customer No.";
                Importance=Promoted;
                OnValidate=BEGIN
                             BilltoCustomerNoOnAfterValidat;
                           END;

                ShowMandatory=TRUE }

    { 96  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ kontaktpersonen pÜ debitorens faktureringsadresse.;
                           ENU=Specifies the number of the contact person at the customer's billing address.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Contact No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ den debitor, som betaler for sagen.;
                           ENU=Specifies the name of the customer who pays for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Name";
                Importance=Promoted }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver adressen pÜ den debitor, som du vil sende fakturaen til.;
                           ENU=Specifies the address of the customer to whom you will send the invoice.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Address";
                Importance=Additional }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en supplerende linje i adressen.;
                           ENU=Specifies an additional line of the address.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Address 2";
                Importance=Additional }

    { 55  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver postnummeret for den debitor, som betaler for sagen.;
                           ENU=Specifies the postal code of the customer who pays for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Post Code";
                Importance=Additional }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver byen i adressen.;
                           ENU=Specifies the city of the address.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to City";
                Importance=Additional }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver landet/omrÜdekoden for debitorens faktureringsadresse.;
                           ENU=Specifies the country/region code of the customer's billing address.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Country/Region Code";
                Importance=Additional }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ kontaktpersonen hos den debitor, som betaler for sagen.;
                           ENU=Specifies the name of the contact person at the customer who pays for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Bill-to Contact";
                Importance=Additional }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en ekstra beskrivelse af sagen med henblik pÜ sõgning.;
                           ENU=Specifies an additional description of the job for searching purposes.];
                ApplicationArea=#Advanced;
                SourceExpr="Search Description";
                Importance=Additional }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver personen i virksomheden, der er ansvarlig for sagen.;
                           ENU=Specifies the person at your company who is responsible for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Person Responsible";
                Importance=Promoted }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at den relaterede record er forhindret i kunne bogfõres under transaktioner - eksempelvis en debitor, som er erklëret insolvent, eller en vare, som er sat i karantëne.;
                           ENU=Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.];
                ApplicationArea=#Jobs;
                SourceExpr=Blocked }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr jobkortet sidst blev ëndret.;
                           ENU=Specifies when the job card was last modified.];
                ApplicationArea=#Jobs;
                SourceExpr="Last Date Modified" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den person, der er tildelt til at administrere sagen.;
                           ENU=Specifies the person who is assigned to manage the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Project Manager";
                Visible=JobSimplificationAvailable }

    { 50  ;1   ;Part      ;
                Name=JobTaskLines;
                CaptionML=[DAN=Opgaver;
                           ENU=Tasks];
                ApplicationArea=#Jobs;
                SubPageView=SORTING(Job Task No.)
                            ORDER(Ascending);
                SubPageLink=Job No.=FIELD(No.);
                PagePartID=Page1001;
                PartType=Page }

    { 1904784501;1;Group  ;
                CaptionML=[DAN=Bogfõring;
                           ENU=Posting] }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en aktuel status for sagen. Du kan ëndre statussen for sagen, efterhÜnden som den skrider frem. Der kan laves efterberegninger for afsluttede sager.;
                           ENU=Specifies a current status of the job. You can change the status for the job as it progresses. Final calculations can be made on completed jobs.];
                ApplicationArea=#Jobs;
                SourceExpr=Status;
                Importance=Promoted;
                OnValidate=BEGIN
                             IF (Status = Status::Completed) AND Complete THEN BEGIN
                               RecalculateJobWIP;
                               CurrPage.UPDATE(FALSE);
                             END;
                           END;
                            }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogfõringsgruppe, der knytter transaktioner, der er foretaget for sagen, til den relevante finanskonto i overensstemmelse med den generelle bogfõringsopsëtning.;
                           ENU=Specifies the posting group that links transactions made for the job with the appropriate general ledger accounts according to the general posting setup.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Posting Group" }

    { 106 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den metode, som anvendes til at beregne vërdien af igangvërende arbejde for sagen.;
                           ENU=Specifies the method that is used to calculate the value of work in process for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Method";
                Importance=Additional }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan bogfõring af igangvërende arbejde udfõres. Pr. sag: De samlede omkostninger til igangvërende arbejde og salgsvërdien bruges til at beregne det igangvërende arbejde. Pr. sagspost: De samlede vërdier for omkostninger til igangvërende arbejde og salg bruges til at beregne det igangvërende arbejde.;
                           ENU=Specifies how WIP posting is performed. Per Job: The total WIP costs and the sales value is used to calculate WIP. Per Job Ledger Entry: The accumulated values of WIP costs and sales are used to calculate WIP.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Posting Method";
                Importance=Additional }

    { 89  ;2   ;Field     ;
                CaptionML=[DAN=Tillad budget/fakturerbare linjer;
                           ENU=Allow Budget/Billable Lines];
                ToolTipML=[DAN=Angiver, om du kan tilfõje planlëgningslinjer bÜde af typen Budget og Fakturerbar til sagen.;
                           ENU=Specifies if you can add planning lines of both type Budget and type Billable to the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Allow Schedule/Contract Lines";
                Importance=Additional }

    { 70  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om forbrugsposter fra f.eks. sagskladde eller kõbslinje, er knyttet til sagsplanlëgningslinjer. MarkÇr dette afkrydsningsfelt, hvis du vil kunne spore de mëngder og belõb for det resterende arbejde, der er nõdvendigt for at fuldfõre en sag og til at oprette en relation mellem efterspõrgsel, planlëgning, forbrug og salg. PÜ et sagskort kan du markere dette afkrydsningsfelt, hvis der ikke er nogen sagsplanlëgningslinjer med typen Budget, som er bogfõrt. Anvendelseslinket gëlder kun for sagsplanlëgningslinjer, der omfatter typen Budget.;
                           ENU=Specifies whether usage entries, from the job journal or purchase line, for example, are linked to job planning lines. Select this check box if you want to be able to track the quantities and amounts of the remaining work needed to complete a job and to create a relationship between demand planning, usage, and sales. On a job card, you can select this check box if there are no existing job planning lines that include type Budget that have been posted. The usage link only applies to job planning lines that include type Budget.];
                ApplicationArea=#Advanced;
                SourceExpr="Apply Usage Link";
                Importance=Additional }

    { 36  ;2   ;Field     ;
                Name=% Completed;
                CaptionML=[DAN=% fuldfõrt;
                           ENU=% Completed];
                ToolTipML=[DAN=Angiver procentdelen af jobbets anslÜede ressourceforbrug, der er bogfõrt som brugt.;
                           ENU=Specifies the percentage of the job's estimated resource usage that has been posted as used.];
                ApplicationArea=#Jobs;
                SourceExpr=PercentCompleted;
                Importance=Promoted;
                Editable=FALSE }

    { 35  ;2   ;Field     ;
                Name=% Invoiced;
                CaptionML=[DAN=% faktureret;
                           ENU=% Invoiced];
                ToolTipML=[DAN=Angiver procentdelen af jobbets fakturavërdi, der er bogfõrt som faktureret.;
                           ENU=Specifies the percentage of the job's invoice value that has been posted as invoiced.];
                ApplicationArea=#Jobs;
                SourceExpr=PercentInvoiced;
                Importance=Promoted;
                Editable=FALSE }

    { 39  ;2   ;Field     ;
                Name=% of Overdue Planning Lines;
                CaptionML=[DAN=% af overskredne planlëgningslinjer;
                           ENU=% of Overdue Planning Lines];
                ToolTipML=[DAN=Angiver procentdelen af jobbets planlëgningslinjer, hvor den planlagte leveringsdato er overskredet.;
                           ENU=Specifies the percentage of the job's planning lines where the planned delivery date has been exceeded.];
                ApplicationArea=#Jobs;
                SourceExpr=PercentOverdue;
                Importance=Additional;
                Editable=FALSE }

    { 1905744101;1;Group  ;
                CaptionML=[DAN=Varighed;
                           ENU=Duration] }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor sagen faktisk pÜbegyndes.;
                           ENU=Specifies the date on which the job actually starts.];
                ApplicationArea=#Jobs;
                SourceExpr="Starting Date";
                Importance=Promoted }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor sagen forventes at vëre afsluttet.;
                           ENU=Specifies the date on which the job is expected to be completed.];
                ApplicationArea=#Jobs;
                SourceExpr="Ending Date";
                Importance=Promoted }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor du opretter sagen.;
                           ENU=Specifies the date on which you set up the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Creation Date" }

    { 1907468901;1;Group  ;
                CaptionML=[DAN=Udenrigshandel;
                           ENU=Foreign Trade] }

    { 98  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver valutakoden for sagen. Valutakoden er som standard tom. Hvis du angiver en kode for en udenlandsk valuta, resulterer det i, at sagen planlëgges og faktureres i den pÜgëldende valuta.;
                           ENU=Specifies the currency code for the job. By default, the currency code is empty. If you enter a foreign currency code, it results in the job being planned and invoiced in that currency.];
                ApplicationArea=#Suite;
                SourceExpr="Currency Code";
                Importance=Promoted }

    { 100 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den valutakode, du vil anvende, nÜr der oprettes fakturaer for en sag. Fakturavalutakoden for en sag er som standard baseret pÜ den valutakode, der er defineret pÜ debitorkortet.;
                           ENU=Specifies the currency code you want to apply when creating invoices for a job. By default, the invoice currency code for a job is based on what currency code is defined on the customer card.];
                ApplicationArea=#Suite;
                SourceExpr="Invoice Currency Code" }

    { 102 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan sagsomkostninger beregnes, hvis du ëndrer feltet Valutadato eller Valutakode pÜ en sagsplanlëgningslinje eller udfõrer kõrslen Rediger datoer for planlëgningslinjer. Fast RV-indstilling: Sagsomkostningerne i den lokale valuta er faste. Eventuelle ëndringer af valutakursen ëndrer vërdien af sagsomkostningerne i udenlandsk valuta. Fast UV-indstilling: Sagsomkostningerne i en udenlandsk valuta er faste. Eventuelle ëndringer af valutakursen ëndrer vërdien af sagsomkostningerne i den lokale valuta.;
                           ENU=Specifies how job costs are calculated if you change the Currency Date or the Currency Code fields on a job planning Line or run the Change Job Planning Line Dates batch job. Fixed LCY option: The job costs in the local currency are fixed. Any change in the currency exchange rate will change the value of job costs in a foreign currency. Fixed FCY option: The job costs in a foreign currency are fixed. Any change in the currency exchange rate will change the value of job costs in the local currency.];
                ApplicationArea=#Suite;
                SourceExpr="Exch. Calculation (Cost)" }

    { 104 ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvordan en sags salgspriser beregnes, hvis du ëndrer feltet Valutadato eller Valutakode pÜ en sagsplanlëgningslinje eller udfõrer kõrslen Rediger datoer for planlëgningslinjer. Fast RV-indstilling: Sagspriserne i den lokale valuta er faste. Eventuelle ëndringer af valutakursen ëndrer vërdien af sagspriserne i en udenlandsk valuta. Fast UV-indstilling: Sagspriserne i en udenlandsk valuta er faste. Eventuelle ëndringer af valutakursen ëndrer vërdien af sagspriserne i den lokale valuta.;
                           ENU=Specifies how job sales prices are calculated if you change the Currency Date or the Currency Code fields on a job planning Line or run the Change Job Planning Line Dates batch job. Fixed LCY option: The job prices in the local currency are fixed. Any change in the currency exchange rate will change the value of job prices in a foreign currency. Fixed FCY option: The job prices in a foreign currency are fixed. Any change in the currency exchange rate will change the value of job prices in the local currency.];
                ApplicationArea=#Suite;
                SourceExpr="Exch. Calculation (Price)" }

    { 1905734501;1;Group  ;
                CaptionML=[DAN=VIA og registrering;
                           ENU=WIP and Recognition] }

    { 7   ;2   ;Group     ;
                CaptionML=[DAN=Til bogfõring;
                           ENU=To Post];
                GroupType=Group }

    { 108 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den bogfõringsdato, der blev angivet, da kõrslen Beregn igangvërende arbejde senest blev udfõrt.;
                           ENU=Specifies the posting date that was entered when the Job Calculate WIP batch job was last run.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Posting Date" }

    { 37  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede salgsbelõb for igangvërende arbejde, som senest blev beregnet for sagen. Salgsbelõbet for igangvërende arbejde er vërdien i vinduet Salg for igangvërende arbejde i sagens poster minus vërdien af vinduet Realiseret salg i sagens poster for igangvërende arbejde. For sager, hvor metoderne Kostvërdi eller Salgsomkostning for igangvërende arbejde benyttes, er salgsbelõbet for igangvërende arbejde normalt 0.;
                           ENU=Specifies the total WIP sales amount that was last calculated for the job. The WIP sales amount is the value in the WIP Sales Job WIP Entries window minus the value of the Recognized Sales Job WIP Entries window. For jobs with the Cost Value or Cost of Sales WIP methods, the WIP sales amount is normally 0.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Sales Amount" }

    { 17  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver summen af alle udlignede salg i finansregnskabet, som er relateret til sagen.;
                           ENU=Specifies the sum of all applied sales in the general ledger that are related to the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Applied Sales G/L Amount";
                Visible=FALSE }

    { 110 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede kostbelõb for igangvërende arbejde, som senest er beregnet for sagen. Omkostningsbelõbet for igangvërende arbejde er vërdien i vinduet Sagsomkostningsposter for igangvërende arbejde minus vërdien i vinduet Realiserede sagsomkostningsposter for igangvërende arbejde. I de sager, hvor metoderne Salgsvërdi eller Fërdiggõrelsesgrad for igangvërende arbejde benyttes, er omkostningsbelõbet for igangvërende arbejde normalt 0.;
                           ENU=Specifies the total WIP cost amount that was last calculated for the job. The WIP cost amount is the value in the WIP Cost Job WIP Entries window minus the value of the Recognized Cost Job WIP Entries window. For jobs with Sales Value or Percentage of Completion WIP methods, the WIP cost amount is normally 0.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Cost Amount" }

    { 19  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver summen af alle de udlignede omkostninger, der er baseret pÜ den valgte sag i finansregnskabet.;
                           ENU=Specifies the sum of all applied costs that is based on to the selected job in the general ledger.];
                ApplicationArea=#Jobs;
                SourceExpr="Applied Costs G/L Amount";
                Visible=FALSE }

    { 16  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det realiserede salgsbelõb, der sidst blev beregnet for sagen, som er summen af posterne i Realiserede salgsposter for igangvërende arbejde.;
                           ENU=Specifies the recognized sales amount that was last calculated for the job, which is the sum of the Recognized Sales Job WIP Entries.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Sales Amount" }

    { 18  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det realiserede kostbelõb, der senest blev beregnet for sagen. Vërdien er summen af de poster i vinduet Realiserede omkostningsposter for igangvërende arbejde.;
                           ENU=Specifies the recognized cost amount that was last calculated for the job. The value is the sum of the entries in the Recognized Cost Job WIP Entries window.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Costs Amount" }

    { 71  ;3   ;Field     ;
                Name=Recog. Profit Amount;
                CaptionML=[DAN=Realiseret avancebelõb;
                           ENU=Recog. Profit Amount];
                ToolTipML=[DAN=Angiver det realiserede avancebelõb for sagen.;
                           ENU=Specifies the recognized profit amount for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcRecognizedProfitAmount }

    { 74  ;3   ;Field     ;
                Name=Recog. Profit %;
                CaptionML=[DAN=Real. avancepct.;
                           ENU=Recog. Profit %];
                ToolTipML=[DAN=Angiver den realiserede avanceprocent for sagen.;
                           ENU=Specifies the recognized profit percentage for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcRecognizedProfitPercentage }

    { 15  ;3   ;Field     ;
                Name=Acc. WIP Costs Amount;
                CaptionML=[DAN=Akkum. VIA-kostbelõb;
                           ENU=Acc. WIP Costs Amount];
                ToolTipML=[DAN=Angiver de samlede VIA-omkostninger for sagen.;
                           ENU=Specifies the total WIP costs for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcAccWIPCostsAmount;
                Visible=FALSE }

    { 13  ;3   ;Field     ;
                Name=Acc. WIP Sales Amount;
                CaptionML=[DAN=Akkum. VIA-salgsbelõb;
                           ENU=Acc. WIP Sales Amount];
                ToolTipML=[DAN=Angiver det samlede VIA-salg for sagen.;
                           ENU=Specifies the total WIP sales for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcAccWIPSalesAmount;
                Visible=FALSE }

    { 11  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver summen af det realiserede salgsbelõb i tilknytning til opgaverne for sagen.;
                           ENU=Specifies the sum of the recognized sales amount that is associated with job tasks for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Calc. Recog. Sales Amount";
                Visible=FALSE }

    { 9   ;3   ;Field     ;
                ToolTipML=[DAN=Angiver summen af det realiserede kostbelõb i tilknytning til opgaverne for sagen.;
                           ENU=Specifies the sum of the recognized costs amount that is associated with job tasks for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Calc. Recog. Costs Amount";
                Visible=FALSE }

    { 5   ;2   ;Group     ;
                CaptionML=[DAN=Bogfõrt;
                           ENU=Posted];
                GroupType=Group }

    { 116 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver den bogfõringsdato, der blev angivet, da kõrslen Bogfõr VIA - finansafstemning senest blev kõrt.;
                           ENU=Specifies the posting date that was entered when the Job Post WIP to General Ledger batch job was last run.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP G/L Posting Date" }

    { 41  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede VIA-salgsbelõb, som senest er bogfõrt i finansregnskabet for sagen. VIA-salgsbelõbet er vërdien i vinduet VIA-salg i VIA-finansposterne for sagen minus vërdien i vinduet Realiseret salg i VIA-posterne for sagen. I de sager, hvor VIA-metoderne Kostvërdi eller Salgsomkostning benyttes, er VIA-salgsbelõbet normalt 0.;
                           ENU=Specifies the total WIP sales amount that was last posted to the general ledger for the job. The WIP sales amount is the value in the WIP Sales Job WIP G/L Entries window minus the value in the Recognized Sales Job WIP G/L Entries window. For jobs with the Cost Value or Cost of Sales WIP methods, the WIP sales amount is normally 0.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Sales G/L Amount" }

    { 118 ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede kostbelõb for igangvërende arbejde, som sidst blev bogfõrt til finansregnskabet for sagen. Kostbelõbet for igangvërende arbejde for sagen er vërdien af VIA-omkostningerne i VIA-finansposterne for sagen minus vërdien af de realiserede omkostninger i VIA-finansposterne for sagen. I de sager, hvor VIA-metoderne Salgsvërdi eller Fërdiggõrelsesgrad benyttes, er VIA-kostbelõbet normalt 0.;
                           ENU=Specifies the total WIP Cost amount that was last posted to the G/L for the job. The WIP Cost Amount for the job is the value WIP Cost Job WIP G/L Entries less the value of the Recognized Cost Job WIP G/L Entries. For jobs with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Cost G/L Amount" }

    { 28  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede realiserede salgsbelõb, som senest blev bogfõrt i finansregnskabet for sagen. Det realiserede salgsfinansbelõb for sagen er summen af posterne i vinduet Realiseret salg i VIA-finansposterne for sagen.;
                           ENU=Specifies the total recognized sales amount that was last posted to the general ledger for the job. The recognized sales G/L amount for the job is the sum of the entries in the Recognized Sales Job WIP G/L Entries window.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Sales G/L Amount" }

    { 29  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede realiserede kostbelõb, som senest blev bogfõrt i finansmodulet for sagen. Det realiserede kostfinansbelõb for sagen er summen af det realiserede omkostninger i VIA-finansposterne for sagen.;
                           ENU=Specifies the total Recognized Cost amount that was last posted to the general ledger for the job. The Recognized Cost G/L amount for the job is the sum of the Recognized Cost Job WIP G/L Entries.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Costs G/L Amount" }

    { 76  ;3   ;Field     ;
                Name=Recog. Profit G/L Amount;
                CaptionML=[DAN=Realiseret avancebelõb, finans;
                           ENU=Recog. Profit G/L Amount];
                ToolTipML=[DAN=Angiver summen af det realiserede avancebelõb i finansposten for sagen.;
                           ENU=Specifies the profit amount that is recognized with the general ledger for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcRecognizedProfitGLAmount }

    { 78  ;3   ;Field     ;
                Name=Recog. Profit G/L %;
                CaptionML=[DAN=Real. avance finanskonto %;
                           ENU=Recog. Profit G/L %];
                ToolTipML=[DAN=Angiver den realiserede avanceprocent i finansposten for sagen.;
                           ENU=Specifies the profit percentage that is recognized with the general ledger for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcRecognProfitGLPercentage }

    { 21  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver summen af det realiserede salgsbelõb i finansregnskabet, som er knyttet til opgaverne for sagen.;
                           ENU=Specifies the sum of the recognized sales general ledger amount that is associated with job tasks for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Calc. Recog. Sales G/L Amount";
                Visible=FALSE }

    { 23  ;3   ;Field     ;
                ToolTipML=[DAN=Angiver summen af det realiserede kostbelõb i finansregnskabet, som er knyttet til opgaverne for sagen.;
                           ENU=Specifies the sum of the recognized costs general ledger amount that is associated with job tasks for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Calc. Recog. Costs G/L Amount";
                Visible=FALSE }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1902018507;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(Bill-to Customer No.);
                PagePartID=Page9082;
                Visible=FALSE;
                PartType=Page }

    { 1902136407;1;Part   ;
                ApplicationArea=#Suite;
                SubPageLink=No.=FIELD(No.),
                            Resource Filter=FIELD(Resource Filter),
                            Posting Date Filter=FIELD(Posting Date Filter),
                            Resource Gr. Filter=FIELD(Resource Gr. Filter),
                            Planning Date Filter=FIELD(Planning Date Filter);
                PagePartID=Page9098;
                Visible=TRUE;
                PartType=Page }

    { 1905650007;1;Part   ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.),
                            Resource Filter=FIELD(Resource Filter),
                            Posting Date Filter=FIELD(Posting Date Filter),
                            Resource Gr. Filter=FIELD(Resource Gr. Filter),
                            Planning Date Filter=FIELD(Planning Date Filter);
                PagePartID=Page9099;
                Visible=FALSE;
                PartType=Page }

    { 44  ;1   ;Part      ;
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
      JobSimplificationAvailable@1000 : Boolean;
      NoFieldVisible@1001 : Boolean;

    LOCAL PROCEDURE BilltoCustomerNoOnAfterValidat@19044114();
    BEGIN
      CurrPage.UPDATE;
    END;

    LOCAL PROCEDURE SetNoFieldVisible@13();
    VAR
      DocumentNoVisibility@1000 : Codeunit 1400;
    BEGIN
      NoFieldVisible := DocumentNoVisibility.JobNoIsVisible;
    END;

    BEGIN
    END.
  }
}

