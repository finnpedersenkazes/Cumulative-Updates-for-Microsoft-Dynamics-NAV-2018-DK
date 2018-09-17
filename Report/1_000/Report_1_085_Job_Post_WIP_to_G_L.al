OBJECT Report 1085 Job Post WIP to G/L
{
  OBJECT-PROPERTIES
  {
    Date=22-02-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20783;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Bogf›r VIA - finansafstemning;
               ENU=Job Post WIP to G/L];
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

    OnPostReport=BEGIN
                   COMMIT;
                   MESSAGE(WIPSuccessfullyPostedMsg);
                 END;

  }
  DATASET
  {
    { 8019;    ;DataItem;                    ;
               DataItemTable=Table167;
               DataItemTableView=SORTING(No.);
               OnAfterGetRecord=BEGIN
                                  JobCalculateWIP.CalcGLWIP("No.",JustReverse,DocNo,PostingDate,ReplacePostDate);
                                END;

               ReqFilterFields=No. }

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
                   DocNo := '';

                   JobsSetup.GET;

                   JobsSetup.TESTFIELD("Job Nos.");
                   NoSeriesMgt.InitSeries(JobsSetup."Job WIP Nos.",JobsSetup."Job WIP Nos.",0D,DocNo,NewNoSeriesCode);

                   ReplacePostDate := FALSE;
                   JustReverse := FALSE;
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
                  Name=ReversalPostingDate;
                  CaptionML=[DAN=Tilbagef›rselsdato;
                             ENU=Reversal Posting Date];
                  ToolTipML=[DAN=Angiver bogf›ringsdatoen for de finansposter, der er bogf›rt af denne funktion.;
                             ENU=Specifies the posting date for the general ledger entries that are posted by this function.];
                  ApplicationArea=#Jobs;
                  SourceExpr=PostingDate }

      { 5   ;2   ;Field     ;
                  Name=ReversalDocumentNo;
                  CaptionML=[DAN=Tilbagef›rselsdokumentnr.;
                             ENU=Reversal Document No.];
                  ToolTipML=[DAN=Angiver et bilagsnummer for de finansposter, der er bogf›rt af denne funktion.;
                             ENU=Specifies a document number for the general ledger entries that are posted by this function.];
                  ApplicationArea=#Jobs;
                  SourceExpr=DocNo }

      { 7   ;2   ;Field     ;
                  Name=ReverseOnly;
                  CaptionML=[DAN=Kun tilbagef›rsel;
                             ENU=Reverse Only];
                  ToolTipML=[DAN=Angiver, at du vil tilbagef›re tidligere bogf›rte VIA-poster, men ikke bogf›re nye VIA-poster til finansregnskabet. Det er f.eks. nyttigt, n†r du har beregnet og bogf›rt VIA-poster for en sag med en forkert dato og vil tilbagef›re de forkerte bogf›ringer uden at bogf›re nye VIA-poster.;
                             ENU=Specifies that you want to reverse previously posted WIP, but not to post new WIP to the general ledger. This is useful, for example, when you have calculated and posted WIP for a job with an incorrect date and want to reverse the incorrect postings without posting new WIP entries.];
                  ApplicationArea=#Jobs;
                  SourceExpr=JustReverse }

      { 4   ;2   ;Field     ;
                  Name=UseReversalDate;
                  CaptionML=[DAN=Brug tilbagef›rselsdato;
                             ENU=Use Reversal Date];
                  ToolTipML=[DAN=Angiver, om du vil bruge tilbagef›rselsdatoen som bogf›ringsdato b†de for tilbagef›rsel af den tidligere VIA-beregning og de nye VIA-beregninger. Det er nyttigt, n†r du vil beregne og bogf›re de historiske VIA-poster for en periode, der allerede er lukket. Du kan tilbagef›re de gamle posteringer og bogf›re den nye beregning i en †ben periode ved at v‘lge en tilbagef›rselsdato i den †bne periode.;
                             ENU=Specifies if you want to use the reversal date as the posting date for both the reversal of the previous WIP calculation and the posting date for the new WIP calculation. This is useful when you want to calculate and post the historical WIP for a period that is already closed. You can reverse the old postings and post the new calculation in an open period by choosing a reversal date in the open period.];
                  ApplicationArea=#Jobs;
                  SourceExpr=ReplacePostDate }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      JobsSetup@1008 : Record 315;
      JobCalculateWIP@1002 : Codeunit 1000;
      JobCalculateBatches@1004 : Codeunit 1005;
      NoSeriesMgt@1007 : Codeunit 396;
      PostingDate@1001 : Date;
      DocNo@1003 : Code[20];
      JustReverse@1000 : Boolean;
      WIPSuccessfullyPostedMsg@1005 : TextConst 'DAN=VIA er bogf›rt.;ENU=WIP was successfully posted to G/L.';
      ReplacePostDate@1006 : Boolean;

    PROCEDURE InitializeRequest@1(NewDocNo@1000 : Code[20]);
    BEGIN
      DocNo := NewDocNo;
      PostingDate := WORKDATE
    END;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

