OBJECT Page 5096 Task List
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
    CaptionML=[DAN=Opgaveliste;
               ENU=Task List];
    SourceTable=Table5080;
    DataCaptionExpr=Caption;
    PageType=List;
    CardPageID=Task Card;
    OnFindRecord=BEGIN
                   RecordsFound := FIND(Which);
                   EXIT(RecordsFound);
                 END;

    OnAfterGetRecord=BEGIN
                       ContactNoOnFormat(FORMAT("Contact No."));
                     END;

    OnAfterGetCurrRecord=BEGIN
                           CALCFIELDS("Contact Name","Contact Company Name");
                         END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 31      ;1   ;ActionGroup;
                      Name=Task;
                      CaptionML=[DAN=Opgave;
                                 ENU=Task];
                      Image=Task }
      { 34      ;2   ;Action    ;
                      CaptionML=[DAN=Be&m‘rkning;
                                 ENU=Co&mment];
                      ToolTipML=[DAN=Se eller tilf›j bem‘rkninger.;
                                 ENU=View or add comments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5072;
                      RunPageLink=Table Name=CONST(To-do),
                                  No.=FIELD(Organizer To-do No.),
                                  Sub No.=CONST(0);
                      Image=ViewComments }
      { 35      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Interaktionslogp&oster;
                                 ENU=Interaction Log E&ntries];
                      ToolTipML=[DAN=F† vist interaktionslogposter for opgaven.;
                                 ENU=View interaction log entries for the task.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5076;
                      RunPageView=SORTING(To-do No.);
                      RunPageLink=To-do No.=FIELD(Organizer To-do No.);
                      Image=InteractionLog }
      { 50      ;2   ;Action    ;
                      CaptionML=[DAN=&Udsatte interaktioner;
                                 ENU=Postponed &Interactions];
                      ToolTipML=[DAN=F† vist udskudte interaktioner for opgaven.;
                                 ENU=View postponed interactions for the task.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 5082;
                      RunPageView=SORTING(To-do No.);
                      RunPageLink=To-do No.=FIELD(Organizer To-do No.);
                      Image=PostponedInteractions }
      { 52      ;2   ;Action    ;
                      CaptionML=[DAN=&Deltagerplanl‘gning;
                                 ENU=A&ttendee Scheduling];
                      ToolTipML=[DAN=F† vist status for et planlagt m›de.;
                                 ENU=View the status of a scheduled meeting.];
                      ApplicationArea=#Advanced;
                      Image=ProfileCalender;
                      OnAction=VAR
                                 Task@1001 : Record 5080;
                               BEGIN
                                 Task.GET("Organizer To-do No.");
                                 PAGE.RUNMODAL(PAGE::"Attendee Scheduling",Task);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=Tildel aktiviteter;
                                 ENU=Assign Activities];
                      ToolTipML=[DAN=F† vist alle de opgaver, der er tildelt til s‘lgere og teams. En opgave kan v‘re at organisere m›der, foretage telefonopkald osv.;
                                 ENU=View all the tasks that have been assigned to salespeople and teams. A task can be organizing meetings, making phone calls, and so on.];
                      ApplicationArea=#RelationshipMgmt;
                      Image=Allocate;
                      OnAction=VAR
                                 TempTask@1001 : TEMPORARY Record 5080;
                               BEGIN
                                 TempTask.AssignActivityFromTask(Rec);
                               END;
                                }
      { 42      ;2   ;Action    ;
                      Name=MakePhoneCall;
                      CaptionML=[DAN=Foretag &tlf.opkald;
                                 ENU=Make &Phone Call];
                      ToolTipML=[DAN=Ring til den valgte kontakt.;
                                 ENU=Call the selected contact.];
                      ApplicationArea=#Advanced;
                      Image=Calls;
                      OnAction=VAR
                                 TempSegmentLine@1001 : TEMPORARY Record 5077;
                                 ContactNo@1002 : Code[10];
                                 ContCompanyNo@1003 : Code[10];
                               BEGIN
                                 IF "Contact No." <> '' THEN
                                   ContactNo := "Contact No."
                                 ELSE
                                   ContactNo := GETFILTER("Contact No.");
                                 IF "Contact Company No." <> '' THEN
                                   ContCompanyNo := "Contact Company No."
                                 ELSE
                                   ContCompanyNo := GETFILTER("Contact Company No.");
                                 IF ContactNo = '' THEN BEGIN
                                   IF (Type = Type::Meeting) AND ("Team Code" = '') THEN
                                     ERROR(Text004);
                                   ERROR(Text005);
                                 END;
                                 TempSegmentLine."To-do No." := "No.";
                                 TempSegmentLine."Contact No." := ContactNo;
                                 TempSegmentLine."Contact Company No." := ContCompanyNo;
                                 TempSegmentLine."Campaign No." := "Campaign No.";
                                 TempSegmentLine."Salesperson Code" := "Salesperson Code";
                                 TempSegmentLine.CreatePhoneCall;
                               END;
                                }
      { 33      ;1   ;Action    ;
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
      { 1034    ;1   ;Action    ;
                      CaptionML=[DAN=Rediger arrang›rs opgave;
                                 ENU=Edit Organizer Task];
                      ToolTipML=[DAN=F† vist generelle oplysninger om opgaverne, f.eks. type, beskrivelse, prioritering og status for opgaven, samt den s‘lger eller det team, som opgaven er knyttet til.;
                                 ENU=View general information about the task such as type, description, priority and status of the task, as well as the salesperson or team the task is assigned to.];
                      ApplicationArea=#RelationshipMgmt;
                      RunObject=Page 5098;
                      RunPageLink=No.=FIELD(Organizer To-do No.);
                      Promoted=No;
                      Image=Edit }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgaven er lukket.;
                           ENU=Specifies that the task is closed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Closed }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor opgaven skal v‘re startet. Der er bestemte regler for, hvordan datoer skal indtastes, som kan ses i vejledningen i angivelse af datoer og klokkesl‘t.;
                           ENU=Specifies the date when the task should be started. There are certain rules for how dates should be entered found in How to: Enter Dates and Times.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Date }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens type.;
                           ENU=Specifies the type of the task.];
                OptionCaptionML=[DAN=" ,,Telefonopkald";
                                 ENU=" ,,Phone Call"];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Type }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen af posten.;
                           ENU=Specifies the description of the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Description }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens prioritet.;
                           ENU=Specifies the priority of the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Priority }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN="Angiver opgavens status. Der er fem indstillinger: Ikke startet; Igangsat; Afsluttet, Venter og Udskudt.";
                           ENU=Specifies the status of the task. There are five options: Not Started, In Progress, Completed, Waiting and Postponed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Status }

    { 45  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† arrang›rens opgave. Du kan ikke ‘ndre oplysningerne i feltet.;
                           ENU=Specifies the number of the organizer's task. The field is not editable.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Organizer To-do No." }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den dato, hvor opgaven blev lukket.;
                           ENU=Specifies the date the task was closed.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Date Closed" }

    { 43  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at opgaven er blevet annulleret.;
                           ENU=Specifies that the task has been canceled.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr=Canceled }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, at der er tildelt en kommentar til opgaven.;
                           ENU=Specifies that a comment has been assigned to the task.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kontakt, som er sammenk‘det med opgaven.;
                           ENU=Specifies the number of the contact linked to the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact No.";
                OnLookup=VAR
                           Task@1000 : Record 5080;
                           Cont@1004 : Record 5050;
                         BEGIN
                           IF Type = Type::Meeting THEN BEGIN
                             Task.SETRANGE("No.","No.");
                             PAGE.RUNMODAL(PAGE::"Attendee Scheduling",Task);
                           END ELSE BEGIN
                             IF Cont.GET("Contact No.") THEN;
                             IF PAGE.RUNMODAL(0,Cont) = ACTION::LookupOK THEN;
                           END;
                         END;
                          }

    { 47  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver kontaktnummeret p† den virksomhed, som den kontakt, der er involveret i opgaven, arbejder for.;
                           ENU=Specifies the contact number of the company for which the contact involved in the task works.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company No.";
                Visible=FALSE }

    { 24  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for den s‘lger, der er tildelt til opgaven.;
                           ENU=Specifies the code of the salesperson assigned to the task.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Salesperson Code" }

    { 22  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver koden for det team, som opgaven er tildelt.;
                           ENU=Specifies the code of the team to which the task is assigned.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Team Code" }

    { 26  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den kampagne, som opgaven er knyttet til.;
                           ENU=Specifies the number of the campaign to which the task is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Campaign No." }

    { 36  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den salgsmulighed, som opgaven er knyttet til.;
                           ENU=Specifies the number of the opportunity to which the task is linked.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Opportunity No." }

    { 14  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="No." }

    { 55  ;1   ;Group      }

    { 56  ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=Kontaktnavn;
                           ENU=Contact Name];
                ToolTipML=[DAN=Angiver navnet p† den kontakt, som denne opgave er tildelt til.;
                           ENU=Specifies the name of the contact to which this task has been assigned.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Name" }

    { 58  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver navnet p† den virksomhed, som den kontakt, der er involveret i opgaven, arbejder for.;
                           ENU=Specifies the name of the company for which the contact involved in the task works.];
                ApplicationArea=#RelationshipMgmt;
                SourceExpr="Contact Company Name" }

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
      Cont@1000 : Record 5050;
      Contact1@1009 : Record 5050;
      Salesperson@1001 : Record 13;
      Campaign@1002 : Record 5071;
      Team@1003 : Record 5083;
      Opp@1004 : Record 5092;
      SegHeader@1005 : Record 5076;
      RecordsFound@1008 : Boolean;
      Text000@1007 : TextConst 'DAN=(Flere);ENU=(Multiple)';
      Text001@1006 : TextConst 'DAN=ikke navngivet;ENU=untitled';
      Text004@1010 : TextConst 'DAN=Funktionen Foretag tlf.opkald til denne opgave er kun tilg‘ngelig i vinduet Deltagerplanl‘gning.;ENU=The Make Phone Call function for this task is available only on the Attendee Scheduling window.';
      Text005@1011 : TextConst 'DAN=Du skal v‘lge en opgave med en tilknyttet kontakt, inden du kan bruge funktionen Foretag tlf.opkald.;ENU=You must select a task with a contact assigned to it before you can use the Make Phone Call function.';

    LOCAL PROCEDURE Caption@1() : Text[260];
    VAR
      CaptionStr@1000 : Text[260];
    BEGIN
      IF Cont.GET(GETFILTER("Contact Company No.")) THEN BEGIN
        Contact1.GET(GETFILTER("Contact Company No."));
        IF Contact1."No." <> Cont."No." THEN
          CaptionStr := COPYSTR(Cont."No." + ' ' + Cont.Name,1,MAXSTRLEN(CaptionStr));
      END;
      IF Cont.GET(GETFILTER("Contact No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Cont."No." + ' ' + Cont.Name,1,MAXSTRLEN(CaptionStr));
      IF Salesperson.GET(GETFILTER("Salesperson Code")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Salesperson.Code + ' ' + Salesperson.Name,1,MAXSTRLEN(CaptionStr));
      IF Team.GET(GETFILTER("Team Code")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Team.Code + ' ' + Team.Name,1,MAXSTRLEN(CaptionStr));
      IF Campaign.GET(GETFILTER("Campaign No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Campaign."No." + ' ' + Campaign.Description,1,MAXSTRLEN(CaptionStr));
      IF Opp.GET(GETFILTER("Opportunity No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + Opp."No." + ' ' + Opp.Description,1,MAXSTRLEN(CaptionStr));
      IF SegHeader.GET(GETFILTER("Segment No.")) THEN
        CaptionStr := COPYSTR(CaptionStr + ' ' + SegHeader."No." + ' ' + SegHeader.Description,1,MAXSTRLEN(CaptionStr));
      IF CaptionStr = '' THEN
        CaptionStr := Text001;

      EXIT(CaptionStr);
    END;

    LOCAL PROCEDURE ContactNoOnFormat@19025756(Text@19019593 : Text[1024]);
    BEGIN
      IF Type = Type::Meeting THEN
        Text := Text000;
    END;

    BEGIN
    END.
  }
}

