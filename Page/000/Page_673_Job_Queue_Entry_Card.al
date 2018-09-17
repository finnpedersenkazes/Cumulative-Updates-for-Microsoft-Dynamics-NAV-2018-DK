OBJECT Page 673 Job Queue Entry Card
{
  OBJECT-PROPERTIES
  {
    Date=30-08-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.24232;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Kort til opgavek�post;
               ENU=Job Queue Entry Card];
    SourceTable=Table472;
    DataCaptionFields=Object Type to Run,Object Caption to Run;
    PageType=Card;
    OnNewRecord=BEGIN
                  ID := CREATEGUID;
                  Status := Status::"On Hold";
                END;

    OnAfterGetCurrRecord=BEGIN
                           IF CurrPage.EDITABLE AND NOT (Status IN [Status::"On Hold",Status::"On Hold with Inactivity Timeout"]) THEN
                             ShowModifyOnlyWhenReadOnlyNotification;
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;  ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 49      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgave&k�;
                                 ENU=Job &Queue];
                      Image=CheckList }
      { 51      ;2   ;Action    ;
                      CaptionML=[DAN=Angiv status som Klar;
                                 ENU=Set Status to Ready];
                      ToolTipML=[DAN=Skift status for posten.;
                                 ENU=Change the status of the entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=ResetStatus;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetStatus(Status::Ready);
                               END;
                                }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=Indstil som Afvent;
                                 ENU=Set On Hold];
                      ToolTipML=[DAN=Skift status for posten.;
                                 ENU=Change the status of the entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Pause;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 SetStatus(Status::"On Hold");
                                 RecallModifyOnlyWhenReadOnlyNotification;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      CaptionML=[DAN=Vis fejl;
                                 ENU=Show Error];
                      ToolTipML=[DAN=Vis fejlmeddelelsen, der har standset posten.;
                                 ENU=Show the error message that has stopped the entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Error;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 ShowErrorMessage;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Restart;
                      CaptionML=[DAN=Genstart;
                                 ENU=Restart];
                      ToolTipML=[DAN=Stop og start posten.;
                                 ENU=Stop and start the entry.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Start;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Restart;
                               END;
                                }
      { 17      ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=Opgave&k�;
                                 ENU=Job &Queue];
                      Image=CheckList }
      { 19      ;2   ;Action    ;
                      Name=LogEntries;
                      CaptionML=[DAN=Logposter;
                                 ENU=Log Entries];
                      ToolTipML=[DAN=Vis logposterne i opgavek�en.;
                                 ENU=View the job queue log entries.];
                      ApplicationArea=#Basic,#Suite;
                      RunObject=Page 674;
                      RunPageLink=ID=FIELD(ID);
                      Promoted=Yes;
                      Image=Log;
                      PromotedCategory=Process }
      { 15      ;2   ;Action    ;
                      Name=ShowRecord;
                      CaptionML=[DAN=Vis record;
                                 ENU=Show Record];
                      ToolTipML=[DAN=Vis recorden for posten.;
                                 ENU=Show the record for the entry.];
                      ApplicationArea=#Basic,#Suite;
                      Image=ViewDetails;
                      OnAction=BEGIN
                                 LookupRecordToProcess;
                               END;
                                }
      { 29      ;2   ;Action    ;
                      Name=ReportRequestPage;
                      CaptionML=[DAN=Siden Rapportanmodning;
                                 ENU=Report Request Page];
                      ToolTipML=[DAN=Vis anmodningssiden for posten. Hvis posten er konfigureret til at k�re en rapport, der kun er til behandling, er anmodningssiden tom.;
                                 ENU=Show the request page for the entry. If the entry is set up to run a processing-only report, the request page is blank.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Enabled="Object Type to Run" = "Object Type to Run"::Report;
                      Image=Report;
                      PromotedCategory=Report;
                      OnAction=BEGIN
                                 RunReportRequestPage;
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
                           ENU=General];
                Editable=Status = Status::"On Hold" }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den objekttype, rapport eller codeunit, der skal aktiveres for opgavek�posten. N�r du har angivet en type, skal du v�lge et objekt-id for den p�g�ldende type i feltet Objekt-id, der skal aktiveres.;
                           ENU=Specifies the type of the object, report or codeunit, that is to be run for the job queue entry. After you specify a type, you then select an object ID of that type in the Object ID to Run field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object Type to Run";
                Importance=Promoted }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for det objekt, der skal aktiveres for denne opgave. Du kan v�lge et id af den objekttype, du har angivet i feltet Objekttype, der skal aktiveres.;
                           ENU=Specifies the ID of the object that is to be run for this job. You can select an ID that is of the object type that you have specified in the Object Type to Run field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object ID to Run";
                Importance=Promoted }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� det objekt, der er valgt i feltet Objekt-id, der skal aktiveres.;
                           ENU=Specifies the name of the object that is selected in the Object ID to Run field.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Object Caption to Run" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af opgavek�posten. Du kan redigere og opdatere beskrivelsen af opgavek�postkortet. Beskrivelsen vises ogs� i vinduet Opgavek�poster, men kan ikke opdateres der. Du kan maksimalt angive 50 tegn, b�de tal og bogstaver.;
                           ENU=Specifies a description of the job queue entry. You can edit and update the description on the job queue entry card. The description is also displayed in the Job Queue Entries window, but it cannot be updated there. You can enter a maximum of 50 characters, both numbers and letters.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Importance=Promoted }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en tekststreng, der anvendes som en parameter til opgavek�en, n�r den aktiveres.;
                           ENU=Specifies a text string that is used as a parameter by the job queue when it is run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Parameter String";
                Importance=Additional }

    { 3   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den opgavek�kategori, som opgavek�posten tilh�rer. V�lg feltet for at v�lge en kode fra listen.;
                           ENU=Specifies the code of the job queue category to which the job queue entry belongs. Choose the field to select a code from the list.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Job Queue Category Code";
                Importance=Additional }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogf�rt posten, der skal bruges, f.eks. i �ndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Importance=Additional }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange gange en opgave i k�en skal k�res igen, n�r en opgavek� ikke kan k�res. Dette er nyttigt i situationer, hvor en opgave ikke reagerer. En opgave reagerer f.eks. ikke, n�r den er afh�ngig af en ekstern ressource, der ikke altid er tilg�ngelig.;
                           ENU=Specifies how many times a job queue task should be rerun after a job queue fails to run. This is useful for situations in which a task might be unresponsive. For example, a task might be unresponsive because it depends on an external resource that is not always available.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Maximum No. of Attempts to Run";
                Importance=Additional }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato og det klokkesl�t, hvor opgavek�posten senest blev angivet til Klar og sendt til opgavek�en.;
                           ENU=Specifies the date and time when the job queue entry was last set to Ready and sent to the job queue.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Last Ready State";
                Importance=Additional }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tidligste dato og det tidligste klokkesl�t for, hvor opgavek�posten skal aktiveres.;
                           ENU=Specifies the earliest date and time when the job queue entry should be run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Earliest Start Date/Time" }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato og det klokkesl�t, hvor opgavek�posten vil udl�be og opgavek�posten ikke l�ngere bliver k�rt.;
                           ENU=Specifies the date and time when the job queue entry is to expire, after which the job queue entry will not be run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Expiration Date/Time";
                Importance=Additional }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver status for opgavek�posten. N�r du opretter en opgavek�post, angives dens status til Afvent. Du kan indstille status til Klar og tilbage til Afvent. Ellers opdateres statusoplysningerne i dette felt automatisk.;
                           ENU=Specifies the status of the job queue entry. When you create a job queue entry, its status is set to On Hold. You can set the status to Ready and back to On Hold. Otherwise, status information in this field is updated automatically.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Status }

    { 21  ;1   ;Group     ;
                CaptionML=[DAN=Rapportparametre;
                           ENU=Report Parameters];
                Visible="Object Type to Run" = "Object Type to Run"::Report;
                Editable=Status = Status::"On Hold";
                GroupType=Group }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om indstillingerne p� rapportanmodningssiden er indstillet for en planlagt rapportopgave. Hvis afkrydsningsfeltet er markeret, er indstillingerne angivet for den planlagte rapport.;
                           ENU=Specifies whether options on the report request page have been set for scheduled report job. If the check box is selected, then options have been set for the scheduled report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Request Page Options" }

    { 27  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver resultatet af den planlagte rapport.;
                           ENU=Specifies the output of the scheduled report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Output Type";
                Importance=Promoted }

    { 25  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken printer der skal bruges til at udskrive den planlagte rapport.;
                           ENU=Specifies the printer to use to print the scheduled report.];
                ApplicationArea=#Advanced;
                SourceExpr="Printer Name" }

    { 1900576001;1;Group  ;
                CaptionML=[DAN=Gentagelse;
                           ENU=Recurrence];
                Editable=Status = Status::"On Hold" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om opgavek�posten gentages. Hvis afkrydsningsfeltet Gentaget opgave er markeret, gentages opgavek�posten. Hvis afkrydsningsfeltet er ryddet, gentages opgavek�posten ikke. Efter du har angivet, at en opgavek�post skal gentages, skal du angive, hvilke dage i ugen opgavek�posten skal k�res. Du kan ogs� angive et tidspunkt p� dagen for opgavek�rslen, og hvor mange minutter der skal g� mellem k�rslerne.;
                           ENU=Specifies if the job queue entry is recurring. If the Recurring Job check box is selected, then the job queue entry is recurring. If the check box is cleared, the job queue entry is not recurring. After you specify that a job queue entry is a recurring one, you must specify on which days of the week the job queue entry is to run. Optionally, you can also specify a time of day for the job to run and how many minutes should elapse between runs.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Recurring Job";
                Editable=FALSE }

    { 28  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek�posten skal k�res p� mandage.;
                           ENU=Specifies that the job queue entry runs on Mondays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Mondays" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek�posten skal k�res p� tirsdage.;
                           ENU=Specifies that the job queue entry runs on Tuesdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Tuesdays" }

    { 32  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek�posten skal k�res p� onsdage.;
                           ENU=Specifies that the job queue entry runs on Wednesdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Wednesdays" }

    { 34  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek�posten skal k�res p� torsdage.;
                           ENU=Specifies that the job queue entry runs on Thursdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Thursdays" }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek�posten skal k�res p� fredage.;
                           ENU=Specifies that the job queue entry runs on Fridays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Fridays" }

    { 38  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek�posten skal k�res p� l�rdage.;
                           ENU=Specifies that the job queue entry runs on Saturdays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Saturdays" }

    { 40  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgavek�posten skal k�res p� s�ndage.;
                           ENU=Specifies that the job queue entry runs on Sundays.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Run on Sundays" }

    { 42  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det tidligste tidspunkt p� dagen, hvor den gentagne opgavek�post skal k�res.;
                           ENU=Specifies the earliest time of the day that the recurring job queue entry is to be run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Starting Time";
                Importance=Promoted;
                Editable="Recurring Job" = TRUE }

    { 44  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det seneste tidspunkt p� dagen, hvor den gentagne opgavek�post skal k�res.;
                           ENU=Specifies the latest time of the day that the recurring job queue entry is to be run.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Ending Time";
                Importance=Promoted;
                Editable="Recurring Job" = TRUE }

    { 46  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver minimumantallet af minutter, der skal forl�be mellem k�rslerne af en opgavek�post. Dette felt har kun betydning, hvis opgavek�posten er indstillet til at v�re et gentaget job.;
                           ENU=Specifies the minimum number of minutes that are to elapse between runs of a job queue entry. This field only has meaning if the job queue entry is set to be a recurring job.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="No. of Minutes between Runs";
                Importance=Promoted;
                Editable="Recurring Job" = TRUE }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvor mange minutter der m� g�, f�r et gentaget job med statussen Afvent automatisk genstartes.;
                           ENU=Specifies how many minutes can pass before a recurring job that has the status On Hold is automatically restarted.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Inactivity Timeout Period" }

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
      ChooseSetOnHoldMsg@1000 : TextConst 'DAN=Hvis du vil redigere opgavek�posten, skal du f�rst v�lge handlingen Indstil som Afvent.;ENU=To edit the job queue entry, you must first choose the Set On Hold action.';
      SetOnHoldLbl@1001 : TextConst 'DAN=Indstil som Afvent;ENU=Set On Hold';
      ModifyOnlyWhenReadOnlyNotificationIdTxt@1002 : TextConst '@@@={Locked};DAN=509FD112-31EC-4CDC-AEBF-19B8FEBA526F;ENU=509FD112-31EC-4CDC-AEBF-19B8FEBA526F';

    [External]
    PROCEDURE GetChooseSetOnHoldMsg@9() : Text;
    BEGIN
      EXIT(ChooseSetOnHoldMsg);
    END;

    LOCAL PROCEDURE GetModifyOnlyWhenReadOnlyNotificationId@23() : GUID;
    VAR
      ModifyOnlyWhenReadOnlyNotificationId@1000 : GUID;
    BEGIN
      EVALUATE(ModifyOnlyWhenReadOnlyNotificationId,ModifyOnlyWhenReadOnlyNotificationIdTxt);
      EXIT(ModifyOnlyWhenReadOnlyNotificationId);
    END;

    LOCAL PROCEDURE RecallModifyOnlyWhenReadOnlyNotification@27();
    VAR
      ModifyOnlyWhenReadOnlyNotification@1000 : Notification;
    BEGIN
      ModifyOnlyWhenReadOnlyNotification.ID := GetModifyOnlyWhenReadOnlyNotificationId;
      ModifyOnlyWhenReadOnlyNotification.RECALL;
    END;

    LOCAL PROCEDURE ShowModifyOnlyWhenReadOnlyNotification@20();
    VAR
      ModifyOnlyWhenReadOnlyNotification@1000 : Notification;
    BEGIN
      ModifyOnlyWhenReadOnlyNotification.ID := GetModifyOnlyWhenReadOnlyNotificationId;
      ModifyOnlyWhenReadOnlyNotification.MESSAGE := GetChooseSetOnHoldMsg;
      ModifyOnlyWhenReadOnlyNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
      ModifyOnlyWhenReadOnlyNotification.SETDATA(FIELDNAME(ID),ID);
      ModifyOnlyWhenReadOnlyNotification.ADDACTION(SetOnHoldLbl,CODEUNIT::"Job Queue - Send Notification",
        'SetJobQueueEntryStatusToOnHold');
      ModifyOnlyWhenReadOnlyNotification.SEND;
    END;

    BEGIN
    END.
  }
}

