OBJECT Page 1027 Job WIP Cockpit
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    Editable=No;
    CaptionML=[DAN=Igangv‘rende arbejder for sag;
               ENU=Job WIP];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table167;
    SourceTableView=WHERE(Status=FILTER(Open|Completed),
                          WIP Completion Posted=CONST(No));
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Definer,Analyser;
                                ENU=New,Process,Report,Define,Analyze];
    ActionList=ACTIONS
    {
      { 15      ;    ;ActionContainer;
                      Name=<Action15>;
                      CaptionML=[DAN=<Handling15>;
                                 ENU=<Action15>];
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;ActionGroup;
                      Name=<Action34>;
                      CaptionML=[DAN=Sag;
                                 ENU=Job];
                      Image=Job }
      { 40      ;2   ;Action    ;
                      CaptionML=[DAN=Sag;
                                 ENU=Job];
                      ToolTipML=[DAN=Vis eller rediger detaljerede oplysninger om sagen.;
                                 ENU=View or edit detailed information about the job.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 88;
                      RunPageOnRec=Yes;
                      Promoted=Yes;
                      Image=JobLedger;
                      PromotedCategory=Category4 }
      { 41      ;2   ;Action    ;
                      CaptionML=[DAN=Sagsopgavelinjer;
                                 ENU=Job Task Lines];
                      ToolTipML=[DAN=Planl‘g, hvordan du vil konfigurere dine planl‘gningsoplysninger. I dette vindue kan du angive, hvilke opgaver sagen omfatter. N†r du vil p†begynde planl‘gningen af en sag eller bogf›re forbrug for en sag, skal du oprette mindst en sagsopgave.;
                                 ENU=Plan how you want to set up your planning information. In this window you can specify the tasks involved in a job. To start planning a job or to post usage for a job, you must set up at least one job task.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1002;
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      Image=TaskList;
                      PromotedCategory=Category4 }
      { 30      ;2   ;Action    ;
                      Name=<Action31>;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Varep&oster;
                                 ENU=Ledger E&ntries];
                      ToolTipML=[DAN=Se historikken over transaktioner, der er bogf›rt for den valgte record.;
                                 ENU=View the history of transactions that have been posted for the selected record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 92;
                      RunPageView=SORTING(Job No.,Job Task No.,Entry Type,Posting Date);
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      Image=JobLedger;
                      PromotedCategory=Category5 }
      { 27      ;2   ;Action    ;
                      Name=<Action30>;
                      ShortCutKey=F7;
                      CaptionML=[DAN=Statistik;
                                 ENU=Statistics];
                      ToolTipML=[DAN=Vis statistiske oplysninger som f.eks. v‘rdien for bogf›rte poster til recorden.;
                                 ENU=View statistical information, such as the value of posted entries, for the record.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1025;
                      RunPageLink=No.=FIELD(No.);
                      Promoted=Yes;
                      Image=Statistics;
                      PromotedCategory=Process }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=V&IA;
                                 ENU=W&IP];
                      Image=WIP }
      { 39      ;2   ;Action    ;
                      CaptionML=[DAN=Vis advarsler;
                                 ENU=Show Warnings];
                      ToolTipML=[DAN=Vis advarselsmeddelelsen for linjer, hvor afkrydsningsfeltet VIA-advarsler er markeret.;
                                 ENU=View the warning message for lines where the WIP Warnings check box is selected.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Find;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Job@1000 : Record 167;
                                 JobWIPWarning@1001 : Record 1007;
                                 TempJobWIPWarning@1002 : TEMPORARY Record 1007;
                               BEGIN
                                 Job.COPY(Rec);
                                 CurrPage.SETSELECTIONFILTER(Job);
                                 IF Job.FINDSET THEN
                                   REPEAT
                                     JobWIPWarning.SETRANGE("Job No.",Job."No.");
                                     IF JobWIPWarning.FINDSET THEN
                                       REPEAT
                                         TempJobWIPWarning := JobWIPWarning;
                                         TempJobWIPWarning.INSERT;
                                       UNTIL JobWIPWarning.NEXT = 0;
                                   UNTIL Job.NEXT = 0;
                                 PAGE.RUNMODAL(PAGE::"Job WIP Warnings",TempJobWIPWarning);
                               END;
                                }
      { 24      ;2   ;Action    ;
                      CaptionML=[DAN=VIA-poster;
                                 ENU=WIP Entries];
                      ToolTipML=[DAN=Vis sagens poster for igangv‘rende arbejde.;
                                 ENU=View the job's WIP entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1008;
                      RunPageView=SORTING(Job No.,Job Posting Group,WIP Posting Date);
                      RunPageLink=Job No.=FIELD(No.);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=WIPEntries;
                      PromotedCategory=Category5 }
      { 17      ;2   ;Action    ;
                      CaptionML=[DAN=VIA-finansposter;
                                 ENU=WIP G/L Entries];
                      ToolTipML=[DAN=Vis sagens finansposter for igangv‘rende arbejde.;
                                 ENU=View the job's WIP G/L entries.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 1009;
                      RunPageView=SORTING(Job No.);
                      RunPageLink=Job No.=FIELD(No.),
                                  Reversed=CONST(No);
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=WIPLedger;
                      PromotedCategory=Category5 }
      { 25      ;0   ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 26      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      ActionContainerType=NewDocumentItems;
                      Image=Action }
      { 45      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Beregn VIA;
                                 ENU=Calculate WIP];
                      ToolTipML=[DAN=Brug en k›rsel som hj‘lp til at beregne v‘rdien af igangv‘rende arbejde (VIA) for dine sager.;
                                 ENU=Use a batch job to help you calculate the value of work in process (WIP) on your jobs.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=CalculateWIP;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Job@1001 : Record 167;
                               BEGIN
                                 TESTFIELD("No.");
                                 Job.COPY(Rec);
                                 Job.SETRANGE("No.","No.");
                                 REPORT.RUNMODAL(REPORT::"Job Calculate WIP",TRUE,FALSE,Job);
                               END;
                                }
      { 44      ;2   ;Action    ;
                      Ellipsis=Yes;
                      CaptionML=[DAN=Bogf›r VIA;
                                 ENU=Post WIP to G/L];
                      ToolTipML=[DAN=Bogf›r sagens VIA-totaler i finansregnskabet.;
                                 ENU=Post the job WIP totals to the general ledger.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
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
      { 38      ;2   ;Action    ;
                      Name=<Action37>;
                      CaptionML=[DAN=Slet VIA-poster;
                                 ENU=Delete WIP Entries];
                      ToolTipML=[DAN=Slet alle VIA-poster for de valgte sager.;
                                 ENU=Delete all WIP entries for the selected jobs.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Delete;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Job@1000 : Record 167;
                                 JobCalculateWIP@1001 : Codeunit 1000;
                               BEGIN
                                 IF CONFIRM(Text001) THEN BEGIN
                                   Job.COPY(Rec);
                                   CurrPage.SETSELECTIONFILTER(Job);
                                   IF Job.FINDSET THEN
                                     REPEAT
                                       JobCalculateWIP.DeleteWIP(Job);
                                     UNTIL Job.NEXT = 0;

                                   MESSAGE(Text002);
                                 END;
                               END;
                                }
      { 37      ;2   ;Action    ;
                      Name=<Action38>;
                      CaptionML=[DAN=Genberegn VIA;
                                 ENU=Recalculate WIP];
                      ToolTipML=[DAN=Beregn igangv‘rende arbejde igen. Hver gang VIA genberegnes, oprettes der en post i vinduet VIA-poster for sag.;
                                 ENU=Calculate the work in process again. Every time WIP is calculated, an entry is created in the Job WIP Entries window.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=CalculateWIP;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 Job@1001 : Record 167;
                                 JobWIPEntry@1003 : Record 1004;
                                 JobCalculateWIP@1000 : Codeunit 1000;
                                 FailedJobs@1004 : Text[1024];
                               BEGIN
                                 IF CONFIRM(Text003) THEN BEGIN
                                   Job.COPY(Rec);
                                   CurrPage.SETSELECTIONFILTER(Job);
                                   IF Job.FINDSET THEN
                                     REPEAT
                                       JobWIPEntry.SETRANGE("Job No.",Job."No.");
                                       IF NOT JobWIPEntry.FINDFIRST THEN
                                         FailedJobs := FailedJobs + Job."No." + ', '
                                       ELSE
                                         JobCalculateWIP.JobCalcWIP(Job,Job."WIP Posting Date",JobWIPEntry."Document No.");
                                     UNTIL Job.NEXT = 0;

                                   IF FailedJobs = '' THEN
                                     MESSAGE(Text004)
                                   ELSE
                                     MESSAGE(Text005,DELSTR(FailedJobs,STRLEN(FailedJobs) - 1,STRLEN(FailedJobs)));
                                 END;
                               END;
                                }
      { 35      ;0   ;ActionContainer;
                      ActionContainerType=Reports }
      { 32      ;1   ;Action    ;
                      Name=<Action32>;
                      CaptionML=[DAN=VIA - finansafstemning;
                                 ENU=Job WIP To G/L];
                      ToolTipML=[DAN=Vis v‘rdien af igangv‘rende arbejde i de sager, som du v‘lger, sammenlignet med de bel›b, der er bogf›rt i finansbogholderiet.;
                                 ENU=View the value of work in process on the jobs that you select compared to the amount that has been posted in the general ledger.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=VAR
                                 Job@1000 : Record 167;
                               BEGIN
                                 TESTFIELD("No.");
                                 Job.COPY(Rec);
                                 Job.SETRANGE("No.","No.");
                                 REPORT.RUNMODAL(REPORT::"Job WIP To G/L",TRUE,FALSE,Job);
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Jobs;
                GroupType=Repeater;
                FreezeColumnID=Description }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagens nummer. Du kan angive nummeret p† en af f›lgende m†der:;
                           ENU=Specifies the number for the job. You can use one of the following methods to fill in the number:];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en kort beskrivelse af sagen.;
                           ENU=Specifies a short description of the job.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om der er knyttet VIA-advarsler til en sag.;
                           ENU=Specifies whether or not there are WIP warnings associated with a job.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Warnings" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det realiserede omkostningsbel›b, der sidst blev beregnet for sagen. Det realiserede omkostningsbel›b for sagen er summen af realiserede omkostninger i VIA-posterne for sagen.;
                           ENU=Specifies the Recognized Cost amount that was last calculated for the job. The Recognized Cost Amount for the job is the sum of the Recognized Cost Job WIP Entries.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Costs Amount" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede realiserede kostbel›b, som senest blev bogf›rt i finansmodulet for sagen. Det realiserede kostfinansbel›b for sagen er summen af det realiserede omkostninger i VIA-finansposterne for sagen.;
                           ENU=Specifies the total Recognized Cost amount that was last posted to the general ledger for the job. The Recognized Cost G/L amount for the job is the sum of the Recognized Cost Job WIP G/L Entries.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Costs G/L Amount" }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det realiserede salgsbel›b, der sidst blev beregnet for sagen, som er summen af posterne i Realiserede salgsposter for igangv‘rende arbejde.;
                           ENU=Specifies the recognized sales amount that was last calculated for the job, which is the sum of the Recognized Sales Job WIP Entries.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Sales Amount" }

    { 21  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede realiserede salgsbel›b, som senest blev bogf›rt i finansmodulet for sagen. Det realiserede salgsfinansbel›b for sagen er summen af det realiserede salg i VIA-finansposterne for sagen.;
                           ENU=Specifies the total Recognized Sales amount that was last posted to the general ledger for the job. The Recognized Sales G/L amount for the job is the sum of the Recognized Sales Job WIP G/L Entries.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Sales G/L Amount" }

    { 22  ;2   ;Field     ;
                Name=Recog. Costs Amount Difference;
                CaptionML=[DAN=Real. kostbel›bsdifference;
                           ENU=Recog. Costs Amount Difference];
                ToolTipML=[DAN=Angiver differencen for sagens realiserede omkostninger.;
                           ENU=Specifies the difference in recognized costs for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Costs Amount" - "Recog. Costs G/L Amount" }

    { 18  ;2   ;Field     ;
                Name=Recog. Sales Amount Difference;
                CaptionML=[DAN=Realiseret salgsbel›bsdifference;
                           ENU=Recog. Sales Amount Difference];
                ToolTipML=[DAN=Angiver differencen for sagens realiserede salg.;
                           ENU=Specifies the difference in recognized sales for the job.];
                ApplicationArea=#Jobs;
                SourceExpr="Recog. Sales Amount" - "Recog. Sales G/L Amount" }

    { 16  ;2   ;Field     ;
                Name=Recog. Profit Amount;
                CaptionML=[DAN=Realiseret avancebel›b;
                           ENU=Recog. Profit Amount];
                ToolTipML=[DAN=Angiver det realiserede avancebel›b for sagen.;
                           ENU=Specifies the recognized profit amount for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcRecognizedProfitAmount }

    { 14  ;2   ;Field     ;
                Name=Recog. Profit G/L Amount;
                CaptionML=[DAN=Realiseret avancebel›b, finans;
                           ENU=Recog. Profit G/L Amount];
                ToolTipML=[DAN=Angiver det realiserede avancebel›b i finansregnskabet for denne sag.;
                           ENU=Specifies the total recognized profit G/L amount for this job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcRecognizedProfitGLAmount }

    { 13  ;2   ;Field     ;
                Name=Recog. Profit Amount Difference;
                CaptionML=[DAN=Realiseret avancebel›bsdifference;
                           ENU=Recog. Profit Amount Difference];
                ToolTipML=[DAN=Angiver differencen for sagens realiserede avance.;
                           ENU=Specifies the difference in recognized profit for the job.];
                ApplicationArea=#Jobs;
                SourceExpr=CalcRecognizedProfitAmount - CalcRecognizedProfitGLAmount }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsdato, der blev angivet, da k›rslen Beregn igangv‘rende arbejde senest blev udf›rt.;
                           ENU=Specifies the posting date that was entered when the Job Calculate WIP batch job was last run.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP Posting Date" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den bogf›ringsdato, der blev angivet, da k›rslen Bogf›r VIA - finansafstemning senest blev k›rt.;
                           ENU=Specifies the posting date that was entered when the Job Post WIP to general ledger batch job was last run.];
                ApplicationArea=#Jobs;
                SourceExpr="WIP G/L Posting Date" }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede kostbel›b for igangv‘rende arbejde, som er beregnet for sagen. Sagens omkostningsbel›b for igangv‘rende arbejde er v‘rdien af omkostningen for igangv‘rende arbejde i sagens poster for igangv‘rende arbejde minus v‘rdien af de realiserede omkostninger i sagens poster for igangv‘rende arbejde. I de sager, hvor metoderne Salgsv‘rdi eller F‘rdigg›relsesgrad for igangv‘rende arbejde benyttes, er omkostningsbel›bet for igangv‘rende arbejde normalt 0.;
                           ENU=Specifies the total WIP cost amount that was last calculated for the job. The WIP Cost Amount for the job is the value WIP Cost Job WIP Entries less the value of the Recognized Cost Job WIP Entries. For jobs with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Cost Amount" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede kostbel›b for igangv‘rende arbejde, som sidst blev bogf›rt til finansregnskabet for sagen. Kostbel›bet for igangv‘rende arbejde for sagen er v‘rdien af VIA-omkostningerne i VIA-finansposterne for sagen minus v‘rdien af de realiserede omkostninger i VIA-finansposterne for sagen. I de sager, hvor VIA-metoderne Salgsv‘rdi eller F‘rdigg›relsesgrad benyttes, er VIA-kostbel›bet normalt 0.;
                           ENU=Specifies the total WIP Cost amount that was last posted to the G/L for the job. The WIP Cost Amount for the job is the value WIP Cost Job WIP G/L Entries less the value of the Recognized Cost Job WIP G/L Entries. For jobs with WIP Methods of Sales Value or Percentage of Completion, the WIP Cost Amount is normally 0.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Cost G/L Amount" }

    { 19  ;2   ;Field     ;
                Name=Total WIP Cost Difference;
                CaptionML=[DAN=Samlet difference, VIA-kostpris;
                           ENU=Total WIP Cost Difference];
                ToolTipML=[DAN=Angiver differencen for samlede VIA-omkostninger.;
                           ENU=Specifies the difference in total WIP costs.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Cost Amount" - "Total WIP Cost G/L Amount" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN="Angiver det samlede salgsbel›b for igangv‘rende arbejde, som senest blev beregnet for sagen. Det er beregnet som v‘rdien i feltet Igangv. arbejder salg minus v‘rdien i feltet Realiseret salg i vinduet VIA-poster for sag. I de sager, hvor VIA-metoderne Kostv‘rdi eller Salgsomkostning benyttes, er VIA-salgsbel›bet normalt 0. ";
                           ENU="Specifies the total WIP sales amount that was last calculated for the job. It is calculated as the value in the WIP Sales field minus the value in the Recognized Sales field in the Job WIP Entries window. For jobs that use the Cost Value or Cost of Sales WIP methods, the WIP sales amount is normally 0. "];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Sales Amount" }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver det samlede salgsbel›b for igangv‘rende arbejde, som senest blev beregnet for sagen. Det er beregnet som v‘rdien i feltet Igangv. arbejder salg minus v‘rdien i feltet Realiseret salg i vinduet VIA - finansafstemning for sag. I de sager, hvor VIA-metoderne Kostv‘rdi eller Salgsomkostning benyttes, er VIA-salgsbel›bet normalt 0. ";
                           ENU="Specifies the total WIP sales amount that was last calculated for the job. It is calculated as the value in the WIP Sales field minus the value in the Recognized Sales field in the Job G/L WIP Entries window. For jobs that use the Cost Value or Cost of Sales WIP methods, the WIP sales amount is normally 0. "];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Sales G/L Amount" }

    { 20  ;2   ;Field     ;
                Name=Total WIP Sales Difference;
                CaptionML=[DAN=Samlet difference, VIA-salgspris;
                           ENU=Total WIP Sales Difference];
                ToolTipML=[DAN=Angiver differencen for samlet VIA-salg.;
                           ENU=Specifies the difference in total WIP sales.];
                ApplicationArea=#Jobs;
                SourceExpr="Total WIP Sales Amount" - "Total WIP Sales G/L Amount" }

    { 28  ;1   ;Part      ;
                ApplicationArea=#Jobs;
                SubPageLink=Job No.=FIELD(No.),
                            Posted to G/L=CONST(No);
                PagePartID=Page1028;
                PartType=Page }

    { 36  ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 34  ;1   ;Part      ;
                ApplicationArea=#Jobs;
                SubPageLink=No.=FIELD(No.),
                            Planning Date Filter=FIELD(Planning Date Filter),
                            Resource Filter=FIELD(Resource Filter),
                            Posting Date Filter=FIELD(Posting Date Filter),
                            Resource Gr. Filter=FIELD(Resource Gr. Filter);
                PagePartID=Page9099;
                Visible=TRUE;
                PartType=Page }

    { 6   ;1   ;Part      ;
                Visible=FALSE;
                PartType=System;
                SystemPartID=RecordLinks }

    { 5   ;1   ;Part      ;
                Visible=TRUE;
                PartType=System;
                SystemPartID=Notes }

  }
  CODE
  {
    VAR
      Text001@1001 : TextConst 'DAN=Er du sikker p†, at du vil slette VIA-posterne for alle valgte sager?;ENU=Are you sure that you want to delete the WIP entries for all selected jobs?';
      Text002@1000 : TextConst 'DAN=VIA-poster blev slettet.;ENU=WIP Entries were deleted successfully.';
      Text003@1002 : TextConst 'DAN=Er du sikker p†, at du vil genberegne VIA-posterne for alle valgte sager?;ENU=Are you sure that you want to recalculate the WIP entries for all selected jobs?';
      Text004@1003 : TextConst 'DAN=VIA-poster blev genberegnet.;ENU=WIP Entries were recalculated successfully.';
      Text005@1004 : TextConst 'DAN=Genberegningen for f›lgende sager lykkedes ikke, da der ikke blev fundet VIA-poster: %1.;ENU=The recalculation for the following jobs failed because no WIP entries were found: %1.';

    BEGIN
    END.
  }
}

