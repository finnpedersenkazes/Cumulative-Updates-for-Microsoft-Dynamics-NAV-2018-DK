OBJECT Page 5098 Task Card
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Opgavekort;
               ENU=Task Card];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table5080;
    PageType=Card;
    OnInit=BEGIN
             CalcDueDateFromEnable := TRUE;
             RecurringDateIntervalEnable := TRUE;
             CompletedByEnable := TRUE;
             AttendeesAcceptedNoEnable := TRUE;
             NoOfAttendeesEnable := TRUE;
             AllDayEventEnable := TRUE;
             LocationEnable := TRUE;
             DurationEnable := TRUE;
             EndingTimeEnable := TRUE;
             StartTimeEnable := TRUE;
             CompletedByEditable := TRUE;
             CalcDueDateFromEditable := TRUE;
             RecurringDateIntervalEditable := TRUE;
             ContactNoEditable := TRUE;
           END;

    OnAfterGetRecord=BEGIN
                       ContactCompanyNameHideValue := FALSE;
                       ContactNameHideValue := FALSE;
                       SwitchCardControls;
                       IF "No." <> "Organizer To-do No." THEN
                         CurrPage.EDITABLE := FALSE
                       ELSE
                         CurrPage.EDITABLE := TRUE;
                       SetRecurringEditable;
                       EnableFields;
                       ContactNoOnFormat(FORMAT("Contact No."));
                       ContactNameOnFormat;
                       ContactCompanyNameOnFormat;
                     END;

    OnModifyRecord=BEGIN
                     IF ("Team Code" = '') AND ("Salesperson Code" = '') THEN
                       ERROR(
                         Text000,TABLECAPTION,FIELDCAPTION("Salesperson Code"),FIELDCAPTION("Team Code"));

                     IF (Type = Type::Meeting) AND (NOT "All Day Event") THEN BEGIN
                       IF "Start Time" = 0T THEN
                         ERROR(Text002,TABLECAPTION,Type,FIELDCAPTION("Start Time"));
                       IF Duration = 0 THEN
                         ERROR(Text002,TABLECAPTION,Type,FIELDCAPTION(Duration));
                     END;
                   END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 29      ;1   ;ActionGroup;
                      CaptionML=[DAN=Op&gave;
                                 ENU=Ta&sk];
                      Image=Task }
      { 33      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m�rkning;
                                 ENU=Co&mment];
                      ToolTipML=[DAN=Se eller tilf�j bem�rkninger.;
                                 ENU=View or add comments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(To-do),
                                  No.=FIELD(Organizer To-do No.),
                                  Sub No.=CONST(0);
                      Image=ViewComments }
      { 34      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=&Interaktionslogposter;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=F� vist interaktionslogposter for opgaven.;
                                 ENU=View interaction log entries for the task.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5076;
                      RunPageView=SORTING(To-do No.);
                      RunPageLink=To-do No.=FIELD(Organizer To-do No.);
                      Image=InteractionLog }
      { 69      ;2   ;Action    ;
                      CaptionML=[DAN=&Udsatte interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=F� vist udskudte interaktioner for opgaven.;
                                 ENU=View postponed interactions for the task.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5082;
                      RunPageView=SORTING(To-do No.);
                      RunPageLink=To-do No.=FIELD(Organizer To-do No.);
                      Image=PostponedInteractions }
      { 70      ;2   ;Action    ;
                      CaptionML=[DAN=&Deltagerplanl�gning;
                                 ENU=A&ttendee Scheduling];
                      ToolTipML=[DAN=F� vist status for et planlagt m�de.;
                                 ENU=View the status of a scheduled meeting.];
                      ApplicationArea=#Advanced;
                      Image=ProfileCalender;
                      OnAction=BEGIN
                                 IF Type <> Type::Meeting THEN
                                   ERROR(CannotSelectAttendeesErr,FORMAT(Type));

                                 PAGE.RUNMODAL(PAGE::"Attendee Scheduling",Rec);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 30      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 35      ;2   ;Action    ;
                      CaptionML=[DAN=Tildel aktiviteter;
                                 ENU=Assign Activities];
                      ToolTipML=[DAN=F� vist alle de opgaver, der er tildelt til s�lgere og teams. En opgave kan v�re at organisere m�der, foretage telefonopkald osv.;
                                 ENU=View all the tasks that have been assigned to salespeople and teams. A task can be organizing meetings, making phone calls, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Allocate;
                      OnAction=VAR
                                 TempTask@1001 : TEMPORARY Record 5080;
                               BEGIN
                                 TempTask.AssignActivityFromTask(Rec)
                               END;
                                }
      { 36      ;2   ;Action    ;
                      Name=MakePhoneCall;
                      CaptionML=[DAN=Foretag &tlf.opkald;
                                 ENU=Make &Phone Call];
                      ToolTipML=[DAN=Ring til den valgte kontakt.;
                                 ENU=Call the selected contact.];
                      ApplicationArea=#Advanced;
                      Image=Calls;
                      OnAction=VAR
                                 TempSegmentLine@1001 : TEMPORARY Record 5077;
                               BEGIN
                                 IF "Contact No." = '' THEN BEGIN
                                   IF (Type = Type::Meeting) AND ("Team Code" = '') THEN
                                     ERROR(MakePhoneCallIsNotAvailableErr);
                                   ERROR(MustAssignContactErr);
                                 END;
                                 TempSegmentLine."To-do No." := "No.";
                                 TempSegmentLine."Contact No." := "Contact No.";
                                 TempSegmentLine."Contact Company No." := "Contact Company No.";
                                 TempSegmentLine."Campaign No." := "Campaign No.";
                                 TempSegmentLine."Salesperson Code" := "Salesperson Code";
                                 TempSegmentLine.CreatePhoneCall;
                               END;
                                }
      { 31      ;1   ;Action    ;
                      CaptionML=[DAN=&Opret opgave;
                                 ENU=&Create Task];
                      ToolTipML=[DAN=Opret en ny opgave.;
                                 ENU=Create a new task.];
                      ApplicationArea=#RelationshipMgmt;
                      Promoted=Yes;
                      Image=NewToDo;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 TempTask@1001 : TEMPORARY Record 5080;
                               BEGIN
                                 TempTask.CreateTaskFromTask(Rec);
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
                ToolTipML=[DAN=Angiver nummeret p� den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No." }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af posten.;
                           ENU=Specifies the description of the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Description }

    { 67  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det sted, hvor m�det skal foreg�.;
                           ENU=Specifies the location where the meeting will take place.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Location;
                Enabled=LocationEnable }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s�lger, der er tildelt til opgaven.;
                           ENU=Specifies the code of the salesperson assigned to the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Salesperson Code";
                OnValidate=BEGIN
                             SalespersonCodeOnAfterValidate;
                           END;
                            }

    { 71  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver antallet af m�dedeltagere. Klik i feltet for at f� vist kortet Deltagerplanl�gning.;
                           ENU=Specifies the number of attendees for the meeting. click the field to view the Attendee Scheduling card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No. of Attendees";
                Enabled=NoOfAttendeesEnable;
                OnDrillDown=BEGIN
                              MODIFY;
                              COMMIT;
                              PAGE.RUNMODAL(PAGE::"Attendee Scheduling",Rec);
                              GET("No.");
                              CurrPage.UPDATE;
                            END;
                             }

    { 73  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det antal deltagere, der har bekr�ftet, at de deltager i m�det.;
                           ENU=Specifies the number of attendees that have confirmed their participation in the meeting.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Attendees Accepted No.";
                Enabled=AttendeesAcceptedNoEnable;
                OnDrillDown=BEGIN
                              MODIFY;
                              COMMIT;
                              PAGE.RUNMODAL(PAGE::"Attendee Scheduling",Rec);
                              GET("No.");
                              CurrPage.UPDATE;
                            END;
                             }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kontakt, som er sammenk�det med opgaven.;
                           ENU=Specifies the number of the contact linked to the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact No.";
                Editable=ContactNoEditable;
                OnValidate=BEGIN
                             ContactNoOnAfterValidate;
                           END;

                OnLookup=VAR
                           Task@1005 : Record 5080;
                           Cont@1003 : Record 5050;
                         BEGIN
                           IF Type = Type::Meeting THEN BEGIN
                             Task.SETRANGE("No.","No.");
                             PAGE.RUNMODAL(PAGE::"Attendee Scheduling",Task);
                           END ELSE BEGIN
                             IF Cont.GET("Contact No.") THEN;
                             IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN BEGIN
                               VALIDATE("Contact No.",Cont."No.");
                               CurrPage.UPDATE;
                             END;
                           END;
                         END;
                          }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den kontakt, som denne opgave er tildelt til.;
                           ENU=Specifies the name of the contact to which this task has been assigned.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name";
                Editable=FALSE;
                HideValue=ContactNameHideValue }

    { 49  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet p� den virksomhed, som den kontakt, der er involveret i opgaven, arbejder for.;
                           ENU=Specifies the name of the company for which the contact involved in the task works.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company Name";
                Editable=FALSE;
                HideValue=ContactCompanyNameHideValue }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det team, som opgaven er tildelt.;
                           ENU=Specifies the code of the team to which the task is assigned.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Team Code";
                OnValidate=BEGIN
                             TeamCodeOnAfterValidate;
                           END;
                            }

    { 76  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den s�lger, som afsluttede denne teamopgave.;
                           ENU=Specifies the salesperson who completed this team task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Completed By";
                Enabled=CompletedByEnable;
                Editable=CompletedByEditable;
                OnValidate=BEGIN
                             SwitchCardControls
                           END;
                            }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver opgavens status. Der er fem indstillinger: Ikke startet; Igangsat; Afsluttet, Venter og Udskudt.";
                           ENU=Specifies the status of the task. There are five options: Not Started, In Progress, Completed, Waiting and Postponed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Status }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens prioritet.;
                           ENU=Specifies the priority of the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Priority }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens type.;
                           ENU=Specifies the type of the task.];
                OptionCaptionML=[DAN=" ,,Telefonopkald";
                                 ENU=" ,,Phone Call"];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Type;
                OnValidate=BEGIN
                             TypeOnAfterValidate;
                           END;
                            }

    { 64  ;2   ;Field     ;
                Name=AllDayEvent;
                CaptionML=[DAN=Hele dagen;
                           ENU=All Day Event];
                ToolTipML=[DAN=Angiver, at opgaven af typen M�de er en heldagsbegivenhed, dvs. en aktivitet, der varer 24 timer eller l�ngere.;
                           ENU=Specifies that the task of the Meeting type is an all-day event, which is an activity that lasts 24 hours or longer.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="All Day Event";
                Enabled=AllDayEventEnable;
                OnValidate=BEGIN
                             AllDayEventOnAfterValidate;
                           END;
                            }

    { 14  ;2   ;Field     ;
                Name=Date;
                ToolTipML=[DAN=Angiver den dato, hvor opgaven skal v�re startet. Der er bestemte regler for, hvordan datoer skal indtastes, som kan ses i vejledningen i angivelse af datoer og klokkesl�t.;
                           ENU=Specifies the date when the task should be started. There are certain rules for how dates should be entered found in How to: Enter Dates and Times.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date }

    { 56  ;2   ;Field     ;
                Name=StartTime;
                ToolTipML=[DAN=Angiver det tidspunkt, hvor opgaven af typen M�de skal v�re startet.;
                           ENU=Specifies the time when the task of the Meeting type should be started.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Start Time";
                Enabled=StartTimeEnable }

    { 58  ;2   ;Field     ;
                Name=Duration;
                ToolTipML=[DAN=Angiver varigheden for opgaven af typen M�de.;
                           ENU=Specifies the duration of the task of the Meeting type.];
                ApplicationArea=#RelationshipMgmt;
                BlankZero=Yes;
                SourceExpr=Duration;
                Enabled=DurationEnable }

    { 63  ;2   ;Field     ;
                Name=EndingDate;
                CaptionML=[DAN=Slutdato;
                           ENU=Ending Date];
                ToolTipML=[DAN=Angiver den dato, hvor opgaven skal v�re afsluttet. Der er bestemte regler for, hvordan datoer skal indtastes. Du kan finde flere oplysninger i vejledningen til angivelse af datoer og klokkesl�t.;
                           ENU=Specifies the date of when the task should end. There are certain rules for how dates should be entered. For more information, see How to: Enter Dates and Times.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Ending Date" }

    { 61  ;2   ;Field     ;
                Name=EndingTime;
                CaptionML=[DAN=Sluttidspunkt;
                           ENU=Ending Time];
                ToolTipML=[DAN=Angiver det tidspunkt, hvor opgaven af typen M�de skal slutte.;
                           ENU=Specifies the time of when the task of the Meeting type should end.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Ending Time";
                Enabled=EndingTimeEnable }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgaven er blevet annulleret.;
                           ENU=Specifies that the task has been canceled.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Canceled;
                OnValidate=BEGIN
                             SwitchCardControls
                           END;
                            }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgaven er lukket.;
                           ENU=Specifies that the task is closed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Closed;
                OnValidate=BEGIN
                             SwitchCardControls
                           END;
                            }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor opgaven blev lukket.;
                           ENU=Specifies the date the task was closed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Date Closed" }

    { 1905354401;1;Group  ;
                CaptionML=[DAN=Relaterede aktiviteter;
                           ENU=Related Activities] }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den kampagne, som opgaven er knyttet til.;
                           ENU=Specifies the number of the campaign to which the task is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No.";
                OnValidate=BEGIN
                             CampaignNoOnAfterValidate;
                           END;
                            }

    { 51  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af den kampagne, som opgaven er knyttet til.;
                           ENU=Specifies the description of the campaign to which the task is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign Description";
                Editable=FALSE }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p� den salgsmulighed, som opgaven er knyttet til.;
                           ENU=Specifies the number of the opportunity to which the task is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity No.";
                OnValidate=BEGIN
                             OpportunityNoOnAfterValidate;
                           END;
                            }

    { 53  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den salgsmulighed, der er relateret til opgaven. Beskrivelsen kopieres fra salgsmulighedskortet.;
                           ENU=Specifies a description of the opportunity related to the task. The description is copied from the opportunity card.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity Description";
                Editable=FALSE }

    { 1904441601;1;Group  ;
                CaptionML=[DAN=Gentagelse;
                           ENU=Recurring] }

    { 39  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgaven forekommer regelm�ssigt.;
                           ENU=Specifies that the task occurs periodically.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Recurring;
                OnValidate=BEGIN
                             RecurringOnPush;
                           END;
                            }

    { 41  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den datoformel, som programmet bruger til automatisk at tildele en tilbagevendende opgave til en s�lger eller et team.;
                           ENU=Specifies the date formula to assign automatically a recurring task to a salesperson or team.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Recurring Date Interval";
                Enabled=RecurringDateIntervalEnable;
                Editable=RecurringDateIntervalEditable }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver datoen, der skal bruges til at beregne den dato, hvor n�ste opgave skal v�re afsluttet.;
                           ENU=Specifies the date to use to calculate the date on which the next task should be completed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Calc. Due Date From";
                Enabled=CalcDueDateFromEnable;
                Editable=CalcDueDateFromEditable }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

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
      Text000@1000 : TextConst 'DAN=%1 vil altid have tilknyttet enten %2 eller %3.;ENU=The %1 will always have either the %2 or %3 assigned.';
      Text002@1002 : TextConst 'DAN=%1 af typen %2 skal altid have tildelt %3.;ENU=The %1 of the %2 type must always have the %3 assigned.';
      CannotSelectAttendeesErr@1005 : TextConst '@@@="%1 = Task Type";DAN=Du kan ikke v�lge deltagere til en opgave af typen ''%1''.;ENU=You cannot select attendees for a task of the ''%1'' type.';
      MakePhoneCallIsNotAvailableErr@1007 : TextConst 'DAN=Funktionen Foretag tlf.opkald til denne opgave er kun tilg�ngelig i vinduet Deltagerplanl�gning.;ENU=The Make Phone Call function for this task is available only in the Attendee Scheduling window.';
      MustAssignContactErr@1008 : TextConst 'DAN=Du skal knytte en kontakt til denne opgave, inden du kan bruge funktionen Foretag tlf.opkald.;ENU=You must assign a contact to this task before you can use the Make Phone Call function.';
      MultipleTxt@1009 : TextConst 'DAN=(Flere);ENU=(Multiple)';
      ContactNameHideValue@19061599 : Boolean INDATASET;
      ContactCompanyNameHideValue@19040407 : Boolean INDATASET;
      ContactNoEditable@19030566 : Boolean INDATASET;
      RecurringDateIntervalEditable@19051941 : Boolean INDATASET;
      CalcDueDateFromEditable@19052355 : Boolean INDATASET;
      CompletedByEditable@19071171 : Boolean INDATASET;
      StartTimeEnable@19008764 : Boolean INDATASET;
      EndingTimeEnable@19050392 : Boolean INDATASET;
      DurationEnable@19035217 : Boolean INDATASET;
      LocationEnable@19013618 : Boolean INDATASET;
      AllDayEventEnable@19049519 : Boolean INDATASET;
      NoOfAttendeesEnable@19000329 : Boolean INDATASET;
      AttendeesAcceptedNoEnable@19007606 : Boolean INDATASET;
      CompletedByEnable@19024761 : Boolean INDATASET;
      RecurringDateIntervalEnable@19019953 : Boolean INDATASET;
      CalcDueDateFromEnable@19036769 : Boolean INDATASET;

    [External]
    PROCEDURE SetRecurringEditable@1();
    BEGIN
      RecurringDateIntervalEditable := Recurring;
      CalcDueDateFromEditable := Recurring;
    END;

    LOCAL PROCEDURE EnableFields@2();
    BEGIN
      RecurringDateIntervalEnable := Recurring;
      CalcDueDateFromEnable := Recurring;

      IF NOT Recurring THEN BEGIN
        EVALUATE("Recurring Date Interval",'');
        CLEAR("Calc. Due Date From");
      END;

      IF Type = Type::Meeting THEN BEGIN
        StartTimeEnable := NOT "All Day Event";
        EndingTimeEnable := NOT "All Day Event";
        DurationEnable := NOT "All Day Event";
        LocationEnable := TRUE;
        AllDayEventEnable := TRUE;
      END ELSE BEGIN
        StartTimeEnable := FALSE;
        EndingTimeEnable := FALSE;
        LocationEnable := FALSE;
        DurationEnable := FALSE;
        AllDayEventEnable := FALSE;
      END;

      GetEndDateTime;
    END;

    LOCAL PROCEDURE SwitchCardControls@3();
    BEGIN
      IF Type = Type::Meeting THEN BEGIN
        ContactNoEditable := FALSE;

        NoOfAttendeesEnable := TRUE;
        AttendeesAcceptedNoEnable := TRUE;
      END ELSE BEGIN
        ContactNoEditable := TRUE;

        NoOfAttendeesEnable := FALSE;
        AttendeesAcceptedNoEnable := FALSE;
      END;
      IF "Team Code" = '' THEN
        CompletedByEnable := FALSE
      ELSE BEGIN
        CompletedByEnable := TRUE;
        CompletedByEditable := NOT Closed
      END
    END;

    LOCAL PROCEDURE TeamCodeOnAfterValidate@19070305();
    BEGIN
      SwitchCardControls;
      CALCFIELDS(
        "No. of Attendees",
        "Attendees Accepted No.",
        "Contact Name",
        "Contact Company Name",
        "Campaign Description",
        "Opportunity Description")
    END;

    LOCAL PROCEDURE ContactNoOnAfterValidate@19009577();
    BEGIN
      CALCFIELDS("Contact Name","Contact Company Name");
    END;

    LOCAL PROCEDURE TypeOnAfterValidate@19069045();
    BEGIN
      EnableFields;
    END;

    LOCAL PROCEDURE AllDayEventOnAfterValidate@19020274();
    BEGIN
      EnableFields;
    END;

    LOCAL PROCEDURE SalespersonCodeOnAfterValidate@19011896();
    BEGIN
      SwitchCardControls;
      CALCFIELDS(
        "No. of Attendees",
        "Attendees Accepted No.",
        "Contact Name",
        "Contact Company Name",
        "Campaign Description",
        "Opportunity Description");
    END;

    LOCAL PROCEDURE CampaignNoOnAfterValidate@19036822();
    BEGIN
      CALCFIELDS("Campaign Description");
    END;

    LOCAL PROCEDURE OpportunityNoOnAfterValidate@19076180();
    BEGIN
      CALCFIELDS("Opportunity Description");
    END;

    LOCAL PROCEDURE RecurringOnPush@19040619();
    BEGIN
      SetRecurringEditable;
    END;

    LOCAL PROCEDURE ContactNoOnFormat@19025756(Text@19019593 : Text[1024]);
    BEGIN
      IF Type = Type::Meeting THEN
        Text := MultipleTxt;
    END;

    LOCAL PROCEDURE ContactNameOnFormat@19032823();
    BEGIN
      IF Type = Type::Meeting THEN
        ContactNameHideValue := TRUE;
    END;

    LOCAL PROCEDURE ContactCompanyNameOnFormat@19053256();
    BEGIN
      IF Type = Type::Meeting THEN
        ContactCompanyNameHideValue := TRUE;
    END;

    BEGIN
    END.
  }
}

