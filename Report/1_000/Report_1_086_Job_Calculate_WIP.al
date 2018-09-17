OBJECT Report 1086 Job Calculate WIP
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Beregn VIA - finansafstemning;
               ENU=Job Calculate WIP];
    ProcessingOnly=Yes;
    OnPreReport=VAR
                  NewNoSeriesCode@1000 : Code[20];
                BEGIN
                  JobsSetup.GET;

                  IF DocNo = '' THEN BEGIN
                    JobsSetup.TESTFIELD("Job Nos.");
                    NoSeriesMgt.InitSeries(JobsSetup."Job WIP Nos.",JobsSetup."Job WIP Nos.",0D,DocNo,NewNoSeriesCode);
                  END;

                  IF PostingDate = 0D THEN
                    PostingDate := WORKDATE;

                  JobCalculateBatches.BatchError(PostingDate,DocNo);
                END;

    OnPostReport=VAR
                   WIPPosted@1001 : Boolean;
                   WIPQst@1002 : Text;
                 BEGIN
                   JobWIPEntry.SETCURRENTKEY("Job No.");
                   JobWIPEntry.SETFILTER("Job No.",Job.GETFILTER("No."));
                   WIPPosted := JobWIPEntry.FINDFIRST;
                   COMMIT;

                   IF WIPPosted THEN BEGIN
                     IF WIPPostedWithWarnings THEN
                       MESSAGE(Text002)
                     ELSE
                       MESSAGE(Text000);
                     IF DIALOG.CONFIRM(PreviewQst) THEN BEGIN
                       JobWIPEntry.SETRANGE("Job No.",Job."No.");
                       PAGE.RUNMODAL(PAGE::"Job WIP Entries",JobWIPEntry);

                       WIPQst := STRSUBSTNO(RunWIPFunctionsQst,'Job Post WIP to G/L');
                       IF DIALOG.CONFIRM(WIPQst) THEN
                         REPORT.RUN(REPORT::"Job Post WIP to G/L",FALSE,FALSE,Job)
                       ELSE
                         REPORT.RUNMODAL(REPORT::"Job Post WIP to G/L",TRUE,FALSE,Job);
                     END;
                   END ELSE
                     MESSAGE(Text001);
                 END;

  }
  DATASET
  {
    { 8019;    ;DataItem;                    ;
               DataItemTable=Table167;
               DataItemTableView=SORTING(No.);
               OnAfterGetRecord=VAR
                                  JobCalculateWIP@1000 : Codeunit 1000;
                                BEGIN
                                  JobCalculateWIP.JobCalcWIP(Job,PostingDate,DocNo);
                                  CALCFIELDS("WIP Warnings");
                                  WIPPostedWithWarnings := WIPPostedWithWarnings OR "WIP Warnings";
                                END;

               ReqFilterFields=No.,Planning Date Filter,Posting Date Filter }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      OnOpenPage=VAR
                   NewNoSeriesCode@1000 : Code[20];
                 BEGIN
                   IF PostingDate = 0D THEN
                     PostingDate := WORKDATE;

                   JobsSetup.GET;

                   JobsSetup.TESTFIELD("Job Nos.");
                   NoSeriesMgt.InitSeries(JobsSetup."Job WIP Nos.",JobsSetup."Job WIP Nos.",0D,DocNo,NewNoSeriesCode);
                 END;

    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 1   ;2   ;Field     ;
                  Name=PostingDate;
                  CaptionML=[DAN=Bogf›ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver bogf›ringsdatoen for bilaget.;
                             ENU=Specifies the posting date for the document.];
                  ApplicationArea=#Jobs;
                  SourceExpr=PostingDate }

      { 5   ;2   ;Field     ;
                  Name=DocumentNo;
                  CaptionML=[DAN=Bilagsnr.;
                             ENU=Document No.];
                  ToolTipML=[DAN=Angiver nummeret p† det bilag, som beregningen g‘lder for.;
                             ENU=Specifies the number of a document that the calculation will apply to.];
                  ApplicationArea=#Jobs;
                  SourceExpr=DocNo }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      JobWIPEntry@1004 : Record 1004;
      JobsSetup@1008 : Record 315;
      JobCalculateBatches@1000 : Codeunit 1005;
      NoSeriesMgt@1009 : Codeunit 396;
      PostingDate@1001 : Date;
      DocNo@1003 : Code[20];
      Text000@1006 : TextConst 'DAN=VIA er beregnet.;ENU=WIP was successfully calculated.';
      Text001@1007 : TextConst 'DAN=Der er ikke oprettet nogen nye VIA-poster.;ENU=There were no new WIP entries created.';
      Text002@1002 : TextConst 'DAN=VIA er beregnet med advarsler.;ENU=WIP was calculated with warnings.';
      WIPPostedWithWarnings@1005 : Boolean;
      PreviewQst@1010 : TextConst 'DAN=Skal bogf›ringskontiene vises som eksempel?;ENU=Do you want to preview the posting accounts?';
      RunWIPFunctionsQst@1011 : TextConst '@@@="%1 = The name of the Job Post WIP to G/L report";DAN=Du skal k›re funktionen %1 for at bogf›re afslutningsposter til denne sag. \Vil du k›re denne funktion nu?;ENU=You must run the %1 function to post the completion entries for this job. \Do you want to run this function now?';

    PROCEDURE InitializeRequest@1();
    BEGIN
      PostingDate := WORKDATE;
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

