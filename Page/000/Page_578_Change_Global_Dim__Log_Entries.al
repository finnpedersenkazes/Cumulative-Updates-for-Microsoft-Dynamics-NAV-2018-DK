OBJECT Page 578 Change Global Dim. Log Entries
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
    CaptionML=[DAN=Logposter;
               ENU=Log Entries];
    SourceTable=Table483;
    SourceTableView=SORTING(Progress)
                    WHERE(Table ID=FILTER(>0));
    PageType=ListPart;
    OnAfterGetRecord=BEGIN
                       IF "Total Records" <> "Completed Records" THEN
                         UpdateStatus;
                       SetStyle;
                     END;

    OnAfterGetCurrRecord=BEGIN
                           IF Status IN [Status::Incomplete,Status::Scheduled] THEN
                             IsRerunEnabled := TRUE
                           ELSE
                             IF Status = Status::" " THEN
                               IsRerunEnabled := NOT AreAllLinesInBlankStatus
                             ELSE
                               IsRerunEnabled := FALSE;
                         END;

    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Action    ;
                      Name=Rerun;
                      AccessByPermission=TableData 483=M;
                      CaptionML=[DAN=K›r igen;
                                 ENU=Rerun];
                      ToolTipML=[DAN=Genstart ikke-fuldf›rte sager til ‘ndring af global dimension. Sager med statussen Ikke fuldf›rt kan standse pga. kapacitetsproblemer. S†danne problemer kan normalt l›ses ved at v‘lge handlingen K›r igen.;
                                 ENU=Restart incomplete jobs for global dimension change. Jobs may stop with the Incomplete status because of capacity issues. Such issues can typically be resolved by choosing the Rerun action.];
                      ApplicationArea=#Suite;
                      Enabled=IsRerunEnabled;
                      Image=RefreshLines;
                      OnAction=VAR
                                 ChangeGlobalDimensions@1000 : Codeunit 483;
                               BEGIN
                                 ChangeGlobalDimensions.Rerun(Rec);
                               END;
                                }
      { 12      ;1   ;Action    ;
                      Name=ShowError;
                      CaptionML=[DAN=Vis fejl;
                                 ENU=Show Error];
                      ToolTipML=[DAN=Vis en meddelelse i vinduet Logposter i opgavek› om den fejl, der har standset k›rslen af ‘ndringerne i de globale dimensioner.;
                                 ENU=View a message in the Job Queue Log Entries window about the error that stopped the global dimension change job.];
                      ApplicationArea=#Suite;
                      Enabled=IsRerunEnabled;
                      Image=ErrorLog;
                      OnAction=BEGIN
                                 ShowError;
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;0   ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Group     ;
                Name=Group;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr="Table ID";
                StyleExpr=Style }

    { 4   ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr="Table Name";
                StyleExpr=Style }

    { 7   ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=Status;
                StyleExpr=Style }

    { 5   ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr="Total Records" }

    { 6   ;2   ;Field     ;
                ApplicationArea=#Suite;
                SourceExpr=Progress }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver sagens resterende varighed.;
                           ENU=Specifies the remaining duration of the job.];
                ApplicationArea=#Suite;
                SourceExpr="Remaining Duration" }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver den tidligste dato og det tidligste klokkesl‘t for, hvorn†r sagen skal k›res.;
                           ENU=Specifies the earliest date and time when the job should be run.];
                ApplicationArea=#Suite;
                SourceExpr="Earliest Start Date/Time";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      IsRerunEnabled@1000 : Boolean;
      Style@1001 : Text INDATASET;

    LOCAL PROCEDURE AreAllLinesInBlankStatus@1() : Boolean;
    VAR
      ChangeGlobalDimLogEntry@1000 : Record 483;
    BEGIN
      ChangeGlobalDimLogEntry.SETFILTER(Status,'<>%1',ChangeGlobalDimLogEntry.Status::" ");
      EXIT(ChangeGlobalDimLogEntry.ISEMPTY);
    END;

    LOCAL PROCEDURE SetStyle@7();
    BEGIN
      CASE Status OF
        Status::" ":
          Style := 'Subordinate';
        Status::Completed:
          Style := 'Favorable';
        Status::Scheduled,
        Status::"In Progress":
          Style := 'Ambiguous';
        Status::Incomplete:
          Style := 'Unfavorable'
      END;
    END;

    BEGIN
    END.
  }
}

