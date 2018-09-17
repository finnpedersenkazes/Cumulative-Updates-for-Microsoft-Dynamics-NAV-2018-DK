OBJECT Page 9506 Session List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Sessionsoversigt;
               ENU=Session List];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000110;
    PageType=List;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Session,SQL-sporing,H‘ndelser;
                                ENU=New,Process,Report,Session,SQL Trace,Events];
    OnOpenPage=BEGIN
                 FILTERGROUP(2);
                 SETFILTER("Server Instance ID",'=%1',SERVICEINSTANCEID);
                 SETFILTER("Session ID",'<>%1',SESSIONID);
                 FILTERGROUP(0);

                 FullSQLTracingStarted := DEBUGGER.ENABLESQLTRACE(0);
               END;

    OnFindRecord=BEGIN
                   CanDebugNextSession := NOT DEBUGGER.ISACTIVE;
                   CanDebugSelectedSession := NOT DEBUGGER.ISATTACHED AND NOT ISEMPTY;

                   // If the session list is empty, insert an empty row to carry the button state to the client
                   IF NOT FIND(Which) THEN BEGIN
                     INIT;
                     "Session ID" := 0;
                   END;

                   EXIT(TRUE);
                 END;

    OnAfterGetRecord=BEGIN
                       IsDebugging := DEBUGGER.ISACTIVE AND ("Session ID" = DEBUGGER.DEBUGGINGSESSIONID);
                       IsDebugged := DEBUGGER.ISATTACHED AND ("Session ID" = DEBUGGER.DEBUGGEDSESSIONID);
                       IsSQLTracing := DEBUGGER.ENABLESQLTRACE("Session ID");
                       IsRowSessionActive := ISSESSIONACTIVE("Session ID");

                       // If this is the empty row, clear the Session ID and Client Type
                       IF "Session ID" = 0 THEN BEGIN
                         SessionIdText := '';
                         ClientTypeText := '';
                       END ELSE BEGIN
                         SessionIdText := FORMAT("Session ID");
                         ClientTypeText := FORMAT("Client Type");
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 9       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Separator  }
      { 13      ;1   ;ActionGroup;
                      Name=Session;
                      CaptionML=[DAN=Session;
                                 ENU=Session] }
      { 11      ;2   ;Action    ;
                      Name=Debug Selected Session;
                      ShortCutKey=Shift+Ctrl+S;
                      CaptionML=[DAN=Fejlfind;
                                 ENU=Debug];
                      ToolTipML=[DAN=Fejlfind den valgte session;
                                 ENU=Debug the selected session];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=CanDebugSelectedSession;
                      PromotedIsBig=Yes;
                      Image=Debug;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 DebuggerManagement.SetDebuggedSession(Rec);
                                 DebuggerManagement.OpenDebuggerTaskPage;
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=Debug Next Session;
                      ShortCutKey=Shift+Ctrl+N;
                      CaptionML=[DAN=Fejlfind n‘ste;
                                 ENU=Debug Next];
                      ToolTipML=[DAN=Fejlfind den n‘ste session, som afbryder k›rslen af kode.;
                                 ENU=Debug the next session that breaks code execution.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=CanDebugNextSession;
                      PromotedIsBig=Yes;
                      Image=DebugNext;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 DebuggedSessionTemp@1001 : Record 2000000110;
                               BEGIN
                                 DebuggedSessionTemp."Session ID" := 0;
                                 DebuggerManagement.SetDebuggedSession(DebuggedSessionTemp);
                                 DebuggerManagement.OpenDebuggerTaskPage;
                               END;
                                }
      { 19      ;1   ;ActionGroup;
                      Name=SQL Trace;
                      CaptionML=[DAN=SQL-sporing;
                                 ENU=SQL Trace] }
      { 20      ;2   ;Action    ;
                      Name=Start Full SQL Tracing;
                      CaptionML=[DAN=Start fuld SQL-sporing;
                                 ENU=Start Full SQL Tracing];
                      ToolTipML=[DAN=Start SQL-sporing.;
                                 ENU=Start SQL tracing.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=NOT FullSQLTracingStarted;
                      Image=Continue;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 DEBUGGER.ENABLESQLTRACE(0,TRUE);
                                 FullSQLTracingStarted := TRUE;
                               END;
                                }
      { 21      ;2   ;Action    ;
                      Name=Stop Full SQL Tracing;
                      CaptionML=[DAN=Stop fuld SQL-sporing;
                                 ENU=Stop Full SQL Tracing];
                      ToolTipML=[DAN=Stop den aktuelle SQL-sporing.;
                                 ENU=Stop the current SQL tracing.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=FullSQLTracingStarted;
                      Image=Stop;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 DEBUGGER.ENABLESQLTRACE(0,FALSE);
                                 FullSQLTracingStarted := FALSE;
                               END;
                                }
      { 17      ;1   ;ActionGroup;
                      Name=Event;
                      CaptionML=[DAN=Begivenhed;
                                 ENU=Event] }
      { 18      ;2   ;Action    ;
                      Name=Subscriptions;
                      CaptionML=[DAN=Abonnementer;
                                 ENU=Subscriptions];
                      ToolTipML=[DAN=Vis abonnementer p† h‘ndelser.;
                                 ENU=Show event subscriptions.];
                      ApplicationArea=#All;
                      RunObject=Page 9510;
                      Promoted=Yes;
                      Image=Event;
                      PromotedCategory=Category6 }
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
                CaptionML=[DAN=Sessions-id;
                           ENU=Session ID];
                ToolTipML=[DAN=Angiver sessionen p† listen.;
                           ENU=Specifies the session in the list.];
                ApplicationArea=#All;
                SourceExpr=SessionIdText;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=Bruger-id;
                           ENU=User ID];
                ToolTipML=[DAN=Angiver brugernavnet p† den bruger, der loggede p† den aktive session.;
                           ENU=Specifies the user name of the user who is logged on to the active session.];
                ApplicationArea=#All;
                SourceExpr="User ID";
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                CaptionML=[DAN=SQL-sporing;
                           ENU=SQL Tracing];
                ToolTipML=[DAN=Angiver, om SQL-sporing er aktiveret.;
                           ENU=Specifies if SQL tracing is enabled.];
                ApplicationArea=#All;
                SourceExpr=IsSQLTracing;
                Editable=IsRowSessionActive;
                OnValidate=BEGIN
                             IsSQLTracing := DEBUGGER.ENABLESQLTRACE("Session ID",IsSQLTracing);
                           END;
                            }

    { 5   ;2   ;Field     ;
                Name=Client Type;
                CaptionML=[DAN=Klienttype;
                           ENU=Client Type];
                ToolTipML=[DAN="Angiver den klienttype, som sessionsh‘ndelsen forekom p†, f.eks. Webtjeneste og Klienttjeneste. ";
                           ENU="Specifies the client type on which the session event occurred, such as Web Service and Client Service . "];
                ApplicationArea=#All;
                SourceExpr=ClientTypeText;
                Editable=FALSE }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Logon-dato;
                           ENU=Login Date];
                ToolTipML=[DAN=Angiver dato og tidspunkt for, hvorn†r sessionen startede p† Dynamics NAV Server-forekomsten.;
                           ENU=Specifies the date and time that the session started on the Dynamics NAV Server instance.];
                ApplicationArea=#All;
                SourceExpr="Login Datetime";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Servercomputernavn;
                           ENU=Server Computer Name];
                ToolTipML=[DAN=Angiver det fuldt kvalificerede dom‘nenavn (FQDN) p† den computer, som Dynamics NAV Server-forekomsten k›rer p†.;
                           ENU=Specifies the fully qualified domain name (FQDN) of the computer on which the Dynamics NAV Server instance runs.];
                ApplicationArea=#All;
                SourceExpr="Server Computer Name";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Serverforekomstnavn;
                           ENU=Server Instance Name];
                ToolTipML=[DAN=Angiver navnet p† den Dynamics NAV Server-forekomst, som sessionen er tilsluttet. Serverforekomstnavnet kommer fra tabellen Sessionsh‘ndelse.;
                           ENU=Specifies the name of the Dynamics NAV Server instance to which the session is connected. The server instance name comes from the Session Event table.];
                ApplicationArea=#All;
                SourceExpr="Server Instance Name";
                Editable=FALSE }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Fejlfinder;
                           ENU=Debugging];
                ToolTipML=[DAN=Angiver sessioner, hvor der foretages fejlfinding.;
                           ENU=Specifies sessions that are being debugged.];
                ApplicationArea=#All;
                SourceExpr=IsDebugging;
                Editable=FALSE }

    { 16  ;2   ;Field     ;
                CaptionML=[DAN=Fejlfundet;
                           ENU=Debugged];
                ToolTipML=[DAN=Angiver sessioner, hvor der er foretaget fejlfinding.;
                           ENU=Specifies debugged sessions.];
                ApplicationArea=#All;
                SourceExpr=IsDebugged;
                Editable=FALSE }

  }
  CODE
  {
    VAR
      DebuggerManagement@1000 : Codeunit 9500;
      CanDebugNextSession@1002 : Boolean INDATASET;
      CanDebugSelectedSession@1003 : Boolean INDATASET;
      FullSQLTracingStarted@1008 : Boolean INDATASET;
      IsDebugging@1004 : Boolean;
      IsDebugged@1005 : Boolean;
      IsSQLTracing@1007 : Boolean;
      IsRowSessionActive@1009 : Boolean;
      SessionIdText@1001 : Text;
      ClientTypeText@1006 : Text;

    BEGIN
    END.
  }
}

