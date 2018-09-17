OBJECT Page 672 Job Queue Entries
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opgavek›poster;
               ENU=Job Queue Entries];
    SourceTable=Table472;
    SourceTableView=SORTING(Priority,Last Ready State);
    PageType=List;
    CardPageID=Job Queue Entry Card;
    OnAfterGetRecord=VAR
                       User@1000 : Record 2000000120;
                     BEGIN
                       UserDoesNotExist := FALSE;
                       IF "User ID" = USERID THEN
                         EXIT;
                       IF User.ISEMPTY THEN
                         EXIT;
                       User.SETRANGE("User Name","User ID");
                       UserDoesNotExist := User.ISEMPTY;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 10      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgave&k›;
                                 ENU=Job &Queue];
                      Image=CheckList }
      { 45      ;2   ;Action    ;
                      Name=ResetStatus;
                      CaptionML=[DAN=Angiv status som Klar;
                                 ENU=Set Status to Ready];
                      ToolTipML=[DAN=Skift status for den valgte post.;
                                 ENU=Change the status of the selected entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ResetStatus;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetStatus(Status::Ready);
                               END;
                                }
      { 46      ;2   ;Action    ;
                      Name=Suspend;
                      CaptionML=[DAN=Indstil som Afvent;
                                 ENU=Set On Hold];
                      ToolTipML=[DAN=Skift status for den valgte post.;
                                 ENU=Change the status of the selected entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Pause;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetStatus(Status::"On Hold");
                               END;
                                }
      { 5       ;2   ;Action    ;
                      Name=ShowError;
                      CaptionML=[DAN=Vis fejl;
                                 ENU=Show Error];
                      ToolTipML=[DAN=Vis fejlmeddelelsen, der har standset posten.;
                                 ENU=Show the error message that has stopped the entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Error;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowErrorMessage;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Restart;
                      CaptionML=[DAN=Genstart;
                                 ENU=Restart];
                      ToolTipML=[DAN=Stop og start den valgte post.;
                                 ENU=Stop and start the selected entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Start;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Restart;
                               END;
                                }
      { 17      ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 15      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgave&k›;
                                 ENU=Job &Queue];
                      Image=CheckList }
      { 19      ;2   ;Action    ;
                      Name=LogEntries;
                      CaptionML=[DAN=Logposter;
                                 ENU=Log Entries];
                      ToolTipML=[DAN=Vis logposterne i opgavek›en.;
                                 ENU=View the job queue log entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 674;
                      RunPageLink=ID=FIELD(ID);
                      Promoted=Yes;
                      Image=Log;
                      PromotedCategory=Process }
      { 21      ;2   ;Action    ;
                      Name=ShowRecord;
                      CaptionML=[DAN=Vis record;
                                 ENU=Show Record];
                      ToolTipML=[DAN=Vis recorden for den valgte post.;
                                 ENU=Show the record for the selected entry.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewDetails;
                      OnAction=BEGIN
                                 LookupRecordToProcess;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=RemoveError;
                      CaptionML=[DAN=Fjern mislykkede poster;
                                 ENU=Remove Failed Entries];
                      ToolTipML=[DAN=Sletter opgavek›poster, der mislykkedes.;
                                 ENU=Deletes the job queue entries that have failed.];
                      ApplicationArea=#Basic,#Suite;
                      Image=Delete;
                      OnAction=BEGIN
                                 RemoveFailedJobs;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for opgavek›posten. N†r du opretter en opgavek›post, angives dens status til Afvent. Du kan indstille status til Klar og tilbage til Afvent. Ellers opdateres statusoplysningerne i dette felt automatisk.;
                           ENU=Specifies the status of the job queue entry. When you create a job queue entry, its status is set to On Hold. You can set the status to Ready and back to On Hold. Otherwise, status information in this field is updated automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf›rt posten, der skal bruges, f.eks. i ‘ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Style=Unfavorable;
                StyleExpr=UserDoesNotExist }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den objekttype, rapport eller codeunit, der skal aktiveres for opgavek›posten. N†r du har angivet en type, skal du v‘lge et objekt-id for den p†g‘ldende type i feltet Objekt-id, der skal aktiveres.;
                           ENU=Specifies the type of the object, report or codeunit, that is to be run for the job queue entry. After you specify a type, you then select an object ID of that type in the Object ID to Run field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object Type to Run" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for det objekt, der skal aktiveres for denne opgave. Du kan v‘lge et id af den objekttype, du har angivet i feltet Objekttype, der skal aktiveres.;
                           ENU=Specifies the ID of the object that is to be run for this job. You can select an ID that is of the object type that you have specified in the Object Type to Run field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object ID to Run" }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p† det objekt, der er valgt i feltet Objekt-id, der skal aktiveres.;
                           ENU=Specifies the name of the object that is selected in the Object ID to Run field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object Caption to Run" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af opgavek›posten. Du kan redigere og opdatere beskrivelsen af opgavek›postkortet. Beskrivelsen vises ogs† i vinduet Opgavek›poster, men kan ikke opdateres der. Du kan maksimalt angive 50 tegn, b†de tal og bogstaver.;
                           ENU=Specifies a description of the job queue entry. You can edit and update the description on the job queue entry card. The description is also displayed in the Job Queue Entries window, but it cannot be updated there. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den opgavek›kategori, som opgavek›posten tilh›rer. V‘lg feltet for at v‘lge en kode fra listen.;
                           ENU=Specifies the code of the job queue category to which the job queue entry belongs. Choose the field to select a code from the list.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Job Queue Category Code" }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dato og klokkesl‘t, hvor en brugersession blev startet.;
                           ENU=Specifies the date and time that a user session started.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User Session Started" }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en tekststreng, der anvendes som en parameter til opgavek›en, n†r den aktiveres.;
                           ENU=Specifies a text string that is used as a parameter by the job queue when it is run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Parameter String";
                Visible=FALSE }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tidligste dato og det tidligste klokkesl‘t for, hvor opgavek›posten skal aktiveres.;
                           ENU=Specifies the earliest date and time when the job queue entry should be run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Earliest Start Date/Time" }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tildelte prioritet for en opgavek›post. Du kan bruge prioriteten til at bestemme, hvilken r‘kkef›lge opgavek›ens poster skal aktiveres i.;
                           ENU=Specifies the assigned priority of a job queue entry. You can use priority to determine the order in which job queue entries are run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Scheduled;
                Style=Unfavorable;
                StyleExpr=NOT Scheduled }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om opgavek›posten gentages. Hvis afkrydsningsfeltet Gentaget opgave er markeret, gentages opgavek›posten. Hvis afkrydsningsfeltet er ryddet, gentages opgavek›posten ikke. Efter du har angivet, at en opgavek›post skal gentages, skal du angive, hvilke dage i ugen opgavek›posten skal k›res. Du kan ogs† angive et tidspunkt p† dagen for opgavek›rslen, og hvor mange minutter der skal g† mellem k›rslerne.;
                           ENU=Specifies if the job queue entry is recurring. If the Recurring Job check box is selected, then the job queue entry is recurring. If the check box is cleared, the job queue entry is not recurring. After you specify that a job queue entry is a recurring one, you must specify on which days of the week the job queue entry is to run. Optionally, you can also specify a time of day for the job to run and how many minutes should elapse between runs.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Recurring Job" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver minimumantallet af minutter, der skal forl›be mellem k›rslerne af en opgavek›post. Dette felt har kun betydning, hvis opgavek›posten er indstillet til at v‘re et gentaget job.;
                           ENU=Specifies the minimum number of minutes that are to elapse between runs of a job queue entry. This field only has meaning if the job queue entry is set to be a recurring job.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Minutes between Runs" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek›posten skal k›res p† mandage.;
                           ENU=Specifies that the job queue entry runs on Mondays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Mondays";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek›posten skal k›res p† tirsdage.;
                           ENU=Specifies that the job queue entry runs on Tuesdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Tuesdays";
                Visible=FALSE }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek›posten skal k›res p† onsdage.;
                           ENU=Specifies that the job queue entry runs on Wednesdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Wednesdays";
                Visible=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek›posten skal k›res p† torsdage.;
                           ENU=Specifies that the job queue entry runs on Thursdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Thursdays";
                Visible=FALSE }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek›posten skal k›res p† fredage.;
                           ENU=Specifies that the job queue entry runs on Fridays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Fridays";
                Visible=FALSE }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek›posten skal k›res p† l›rdage.;
                           ENU=Specifies that the job queue entry runs on Saturdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Saturdays";
                Visible=FALSE }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek›posten skal k›res p† s›ndage.;
                           ENU=Specifies that the job queue entry runs on Sundays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Sundays";
                Visible=FALSE }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidligste tidspunkt p† dagen, hvor den gentagne opgavek›post skal k›res.;
                           ENU=Specifies the earliest time of the day that the recurring job queue entry is to be run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Starting Time";
                Visible=FALSE }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det seneste tidspunkt p† dagen, hvor den gentagne opgavek›post skal k›res.;
                           ENU=Specifies the latest time of the day that the recurring job queue entry is to be run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ending Time";
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
    VAR
      UserDoesNotExist@1000 : Boolean;

    LOCAL PROCEDURE RemoveFailedJobs@1();
    VAR
      JobQueueEntry@1001 : Record 472;
      FailedJobQueueEntry@1000 : Query 472;
    BEGIN
      // Don't remove jobs that have just failed (i.e. last 30 sec)
      FailedJobQueueEntry.SETRANGE(End_Date_Time,0DT,CURRENTDATETIME - 30000);
      FailedJobQueueEntry.OPEN;

      WHILE FailedJobQueueEntry.READ DO BEGIN
        IF JobQueueEntry.GET(FailedJobQueueEntry.ID) THEN
          JobQueueEntry.DELETE(TRUE);
      END;
    END;

    BEGIN
    END.
  }
}

