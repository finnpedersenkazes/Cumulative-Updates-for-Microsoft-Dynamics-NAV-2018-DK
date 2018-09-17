OBJECT Page 9500 Debugger
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
    CaptionML=[DAN=Debugger;
               ENU=Debugger];
    LinksAllowed=No;
    SourceTable=Table2000000110;
    DataCaptionExpr=DataCaption;
    PageType=Card;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Kodesporing,Programkode,Breakpoints,Vis;
                                ENU=New,Process,Report,Code Tracking,Running Code,Breakpoints,Show];
    ShowFilter=No;
    OnInit=BEGIN
             BreakOnError := TRUE;
             BreakpointHit := DEBUGGER.ISBREAKPOINTHIT;
             BreakEnabled := NOT BreakpointHit;
           END;

    OnOpenPage=VAR
                 DebuggedSession@1000 : Record 2000000110;
               BEGIN
                 StartTime := CURRENTDATETIME;
                 FinishTime := StartTime;
                 DebuggerManagement.GetDebuggedSession(DebuggedSession);
                 IF DebuggedSession."Session ID" = 0 THEN
                   DEBUGGER.ACTIVATE
                 ELSE BEGIN
                   DEBUGGER.ATTACH(DebuggedSession."Session ID");
                   SetAttachedSession := TRUE;
                 END;

                 IF UserPersonalization.GET(USERSECURITYID) THEN BEGIN
                   BreakOnError := UserPersonalization."Debugger Break On Error";
                   BreakOnRecordChanges := UserPersonalization."Debugger Break On Rec Changes";
                   SkipCodeunit1 := UserPersonalization."Debugger Skip System Triggers";
                 END;

                 IF BreakOnError THEN
                   DEBUGGER.BREAKONERROR(TRUE);
                 IF BreakOnRecordChanges THEN
                   DEBUGGER.BREAKONRECORDCHANGES(TRUE);
                 IF SkipCodeunit1 THEN
                   DEBUGGER.SKIPSYSTEMTRIGGERS(TRUE);

                 DebuggerManagement.ResetActionState;
               END;

    OnClosePage=BEGIN
                  IF DEBUGGER.DEACTIVATE THEN;
                  SetAttachedSession := FALSE;
                END;

    OnFindRecord=VAR
                   DebuggedSession@1003 : Record 2000000110;
                   IsBreakOnErrorMessageNew@1001 : Boolean;
                   BreakOnErrorMessage@1002 : Text;
                 BEGIN
                   IF NOT DEBUGGER.ISACTIVE AND (Which = '=') THEN
                     MESSAGE(Text007Msg);

                   IF NOT DEBUGGER.ISACTIVE THEN BEGIN
                     CurrPage.CLOSE;
                     EXIT(FALSE);
                   END;

                   BreakpointHit := DEBUGGER.ISBREAKPOINTHIT;

                   IF BreakpointHit THEN BEGIN
                     BreakOnErrorMessage := DebuggerManagement.GetLastErrorMessage(IsBreakOnErrorMessageNew);

                     IF IsBreakOnErrorMessageNew AND (BreakOnErrorMessage <> '') THEN
                       MESSAGE(STRSUBSTNO(Text002Msg,BreakOnErrorMessage));

                     ShowLastErrorEnabled := (BreakOnErrorMessage <> '') OR (DEBUGGER.GETLASTERRORTEXT <> '');

                     BreakEnabled := FALSE;
                     IF NOT SetAttachedSession THEN BEGIN
                       DebuggedSession."Session ID" := DEBUGGER.DEBUGGEDSESSIONID;
                       DebuggerManagement.SetDebuggedSession(DebuggedSession);
                       SetAttachedSession := TRUE;
                     END;
                   END ELSE BEGIN
                     IsBreakOnErrorMessageNew := FALSE;
                     ShowLastErrorEnabled := FALSE;
                     DataCaption := Text004Cap;
                   END;

                   EXIT(TRUE);
                 END;

    OnAfterGetRecord=BEGIN
                       IF BreakpointHit THEN BEGIN
                         CurrPage.Callstack.PAGE.GetCurrentCallstack(DebuggerCallstack);
                         WITH DebuggerCallstack DO BEGIN
                           IF ID <> 0 THEN
                             DataCaption := STRSUBSTNO(Text003Cap,"Object Type","Object ID","Object Name")
                           ELSE
                             DataCaption := Text004Cap;
                         END;
                         FinishTime := CURRENTDATETIME;
                       END;
                     END;

    ActionList=ACTIONS
    {
      { 4       ;    ;ActionContainer;
                      Name=Debugger Actions;
                      CaptionML=[DAN=Debuggerhandlinger;
                                 ENU=Debugger Actions];
                      ActionContainerType=ActionItems }
      { 25      ;1   ;Separator  }
      { 26      ;1   ;ActionGroup;
                      Name=Code Tracking;
                      CaptionML=[DAN=Kodesporing;
                                 ENU=Code Tracking] }
      { 8       ;2   ;Action    ;
                      Name=Step Into;
                      ShortCutKey=F11;
                      CaptionML=[DAN=Trin ind;
                                 ENU=Step Into];
                      ToolTipML=[DAN=Gennemf›r den aktuelle angivelse. Hvis angivelsen indeholder et funktionskald, skal du gennemf›re funktionen og afbryde ved den f›rste angivelse inden for funktionen.;
                                 ENU=Execute the current statement. If the statement contains a function call, then execute the function and break at the first statement inside the function.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=BreakpointHit;
                      PromotedIsBig=Yes;
                      Image=StepInto;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 StartTime := CURRENTDATETIME;
                                 WaitingForBreak;
                                 DebuggerManagement.SetCodeTrackingAction;
                                 DEBUGGER.STEPINTO;
                                 FinishTime := CURRENTDATETIME;
                               END;
                                }
      { 7       ;2   ;Action    ;
                      Name=Step Over;
                      ShortCutKey=F10;
                      CaptionML=[DAN=Trin over;
                                 ENU=Step Over];
                      ToolTipML=[DAN=Gennemf›r den aktuelle angivelse. Hvis angivelsen indeholder et funktionskald, skal du gennemf›re funktionen og afbryde ved den f›rste angivelse uden for funktionen.;
                                 ENU=Execute the current statement. If the statement contains a function call, then execute the function and break at the first statement outside the function.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=BreakpointHit;
                      PromotedIsBig=Yes;
                      Image=StepOver;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 StartTime := CURRENTDATETIME;
                                 WaitingForBreak;
                                 DebuggerManagement.SetCodeTrackingAction;
                                 DEBUGGER.STEPOVER;
                                 FinishTime := CURRENTDATETIME;
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Step Out;
                      ShortCutKey=Shift+F11;
                      CaptionML=[DAN=Trin ud;
                                 ENU=Step Out];
                      ToolTipML=[DAN=Udf›r de resterende angivelser i den aktuelle funktion, og afbryd ved n‘ste angivelse i kaldefunktionen.;
                                 ENU=Execute the remaining statements in the current function and break at the next statement in the calling function.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=BreakpointHit;
                      PromotedIsBig=Yes;
                      Image=StepOut;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 StartTime := CURRENTDATETIME;
                                 WaitingForBreak;
                                 DebuggerManagement.SetCodeTrackingAction;
                                 DEBUGGER.STEPOUT;
                                 FinishTime := CURRENTDATETIME;
                               END;
                                }
      { 11      ;1   ;Separator  }
      { 27      ;1   ;ActionGroup;
                      Name=Running Code;
                      CaptionML=[DAN=Programkode;
                                 ENU=Running Code] }
      { 12      ;2   ;Action    ;
                      Name=Continue;
                      ShortCutKey=F5;
                      CaptionML=[DAN=Forts‘t;
                                 ENU=Continue];
                      ToolTipML=[DAN=Forts‘t indtil n‘ste afbrydelse.;
                                 ENU=Continue until the next break.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=BreakpointHit;
                      PromotedIsBig=Yes;
                      Image=Continue;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 StartTime := CURRENTDATETIME;
                                 WaitingForBreak;
                                 DebuggerManagement.SetRunningCodeAction;
                                 DEBUGGER.CONTINUE;
                                 FinishTime := CURRENTDATETIME;
                               END;
                                }
      { 31      ;2   ;Action    ;
                      Name=Break;
                      ShortCutKey=Shift+Ctrl+B;
                      CaptionML=[DAN=Afbryd;
                                 ENU=Break];
                      ToolTipML=[DAN=Afbryd ved n‘ste angivelse.;
                                 ENU=Break at the next statement.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=BreakEnabled;
                      PromotedIsBig=Yes;
                      Image=Pause;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 BreakEnabled := FALSE;
                                 DebuggerManagement.SetRunningCodeAction;
                                 DEBUGGER."BREAK";
                                 FinishTime := CURRENTDATETIME;
                               END;
                                }
      { 15      ;2   ;Action    ;
                      Name=Stop;
                      ShortCutKey=Shift+F5;
                      CaptionML=[DAN=Stop;
                                 ENU=Stop];
                      ToolTipML=[DAN=Stands den aktuelle aktivitet i den session, der foretages fejlfinding af, mens fejlfindingen af sessionen forts‘tter.;
                                 ENU=Stop the current activity in the session being debugged while continuing to debug the session.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=BreakpointHit;
                      PromotedIsBig=Yes;
                      Image=Stop;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 WaitingForBreak;
                                 DebuggerManagement.SetRunningCodeAction;
                                 DEBUGGER.STOP;
                                 FinishTime := CURRENTDATETIME;
                               END;
                                }
      { 21      ;1   ;Separator  }
      { 28      ;1   ;ActionGroup;
                      Name=Breakpoints Group;
                      CaptionML=[DAN=Breakpoints;
                                 ENU=Breakpoints] }
      { 14      ;2   ;Action    ;
                      Name=Toggle;
                      ShortCutKey=F9;
                      CaptionML=[DAN=Skift;
                                 ENU=Toggle];
                      ToolTipML=[DAN=Skift til og fra et breakpoint p† den aktuelle linje.;
                                 ENU=Toggle a breakpoint at the current line.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ToggleBreakpoint;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 CurrPage.CodeViewer.PAGE.ToggleBreakpoint;
                               END;
                                }
      { 13      ;2   ;Action    ;
                      Name=Set/Clear Condition;
                      ShortCutKey=Shift+F9;
                      CaptionML=[DAN=Angiv/slet betingelse;
                                 ENU=Set/Clear Condition];
                      ToolTipML=[DAN=Angiv eller ryd en breakpoint-betingelse p† den aktuelle linje.;
                                 ENU=Set or clear a breakpoint condition at the current line.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ConditionalBreakpoint;
                      PromotedCategory=Category6;
                      OnAction=BEGIN
                                 CurrPage.CodeViewer.PAGE.SetBreakpointCondition;
                               END;
                                }
      { 19      ;2   ;Action    ;
                      Name=Disable All;
                      CaptionML=[DAN=Deaktiver alle;
                                 ENU=Disable All];
                      ToolTipML=[DAN=Deaktiver alle breakpoints i oversigten over breakpoints. Du kan redigere oversigten med handlingen Breakpoints.;
                                 ENU=Disable all breakpoints in the breakpoint list. You can edit the list by using the Breakpoints action.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=DisableAllBreakpoints;
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 DebuggerBreakpoint@1001 : Record 2000000100;
                               BEGIN
                                 DebuggerBreakpoint.MODIFYALL(Enabled,FALSE,TRUE);
                               END;
                                }
      { 20      ;2   ;Action    ;
                      Name=Breakpoints;
                      CaptionML=[DAN=Breakpoints;
                                 ENU=Breakpoints];
                      ToolTipML=[DAN=Rediger oversigten over breakpoints for alle objekter.;
                                 ENU=Edit the breakpoint list for all objects.];
                      ApplicationArea=#All;
                      RunObject=Page 9505;
                      Promoted=Yes;
                      Image=BreakpointsList;
                      PromotedCategory=Category6 }
      { 35      ;2   ;Action    ;
                      Name=Break Rules;
                      CaptionML=[DAN=Regler for afbrydelse;
                                 ENU=Break Rules];
                      ToolTipML=[DAN=Skift indstillinger for regler for afbrydelse. Debugger afbryder k›rslen af kode for visse konfigurerbare regler samt for breakpoints.;
                                 ENU=Change settings for break rules. The debugger breaks code execution for certain configurable rules as well as for breakpoints.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=BreakRulesList;
                      PromotedCategory=Category6;
                      OnAction=VAR
                                 DebuggerBreakRulesPage@1000 : Page 9509;
                               BEGIN
                                 DebuggerBreakRulesPage.SetBreakOnError(BreakOnError);
                                 DebuggerBreakRulesPage.SetBreakOnRecordChanges(BreakOnRecordChanges);
                                 DebuggerBreakRulesPage.SetSkipCodeunit1(SkipCodeunit1);

                                 IF DebuggerBreakRulesPage.RUNMODAL = ACTION::OK THEN BEGIN
                                   BreakOnError := DebuggerBreakRulesPage.GetBreakOnError;
                                   DEBUGGER.BREAKONERROR(BreakOnError);
                                   BreakOnRecordChanges := DebuggerBreakRulesPage.GetBreakOnRecordChanges;
                                   DEBUGGER.BREAKONRECORDCHANGES(BreakOnRecordChanges);
                                   SkipCodeunit1 := DebuggerBreakRulesPage.GetSkipCodeunit1;
                                   DEBUGGER.SKIPSYSTEMTRIGGERS(SkipCodeunit1);

                                   SaveConfiguration;
                                 END;
                               END;
                                }
      { 22      ;1   ;Separator  }
      { 33      ;1   ;ActionGroup;
                      Name=Show;
                      CaptionML=[DAN=Vis;
                                 ENU=Show];
                      Image=View }
      { 6       ;2   ;Action    ;
                      Name=Variables;
                      ShortCutKey=Shift+Ctrl+V;
                      CaptionML=[DAN=Variabler;
                                 ENU=Variables];
                      ToolTipML=[DAN=Vis oversigten over variabler i det aktuelle omr†de.;
                                 ENU=View the list of variables in the current scope.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=BreakpointHit;
                      PromotedIsBig=Yes;
                      Image=VariableList;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 DebuggerCallstack@1001 : Record 2000000101;
                                 DebuggerVariable@1003 : Record 2000000102;
                               BEGIN
                                 CurrPage.Callstack.PAGE.GetCurrentCallstack(DebuggerCallstack);

                                 DebuggerVariable.FILTERGROUP(2);
                                 DebuggerVariable.SETRANGE("Call Stack ID",DebuggerCallstack.ID);
                                 DebuggerVariable.FILTERGROUP(0);

                                 PAGE.RUNMODAL(PAGE::"Debugger Variable List",DebuggerVariable);
                               END;
                                }
      { 36      ;2   ;Action    ;
                      Name=LastErrorMessage;
                      CaptionML=[DAN=Sidste fejl;
                                 ENU=Last Error];
                      ToolTipML=[DAN=Vis den seneste fejlmeddelelse, som er vist af den session, der foretages fejlfinding af.;
                                 ENU=View the last error message shown by the session being debugged.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Enabled=ShowLastErrorEnabled;
                      PromotedIsBig=Yes;
                      Image=PrevErrorMessage;
                      PromotedCategory=Category7;
                      OnAction=VAR
                                 DebuggerManagement@1003 : Codeunit 9500;
                                 LastErrorMessage@1001 : Text;
                                 IsLastErrorMessageNew@1002 : Boolean;
                               BEGIN
                                 LastErrorMessage := DebuggerManagement.GetLastErrorMessage(IsLastErrorMessageNew);

                                 IF LastErrorMessage = '' THEN
                                   LastErrorMessage := DEBUGGER.GETLASTERRORTEXT;

                                 MESSAGE(STRSUBSTNO(Text005Msg,LastErrorMessage));
                               END;
                                }
    }
  }
  CONTROLS
  {
    { 1   ;    ;Container ;
                ContainerType=ContentArea }

    { 2   ;1   ;Part      ;
                Name=CodeViewer;
                CaptionML=[DAN=Kode;
                           ENU=Code];
                ApplicationArea=#All;
                SubPageLink=Object Type=FIELD(Object Type),
                            Object ID=FIELD(Object ID),
                            Line No.=FIELD(Line No.),
                            ID=FIELD(ID);
                PagePartID=Page9504;
                ProviderID=10 }

    { 16  ;1   ;Field     ;
                CaptionML=[DAN=Varighed;
                           ENU=Duration];
                ToolTipML=[DAN=Angiver, hvor lang tid det tager at k›re fejlfindingen.;
                           ENU=Specifies how long the debugger will take to run.];
                ApplicationArea=#All;
                SourceExpr=FinishTime - StartTime }

    { 3   ;0   ;Container ;
                ContainerType=FactBoxArea }

    { 5   ;1   ;Part      ;
                Name=Watches;
                CaptionML=[DAN=Kontroller;
                           ENU=Watches];
                ApplicationArea=#All;
                SubPageLink=Call Stack ID=FIELD(ID);
                PagePartID=Page9503;
                ProviderID=10 }

    { 10  ;1   ;Part      ;
                Name=Callstack;
                CaptionML=[DAN=Kaldestak;
                           ENU=Call Stack];
                ApplicationArea=#All;
                PagePartID=Page9502 }

  }
  CODE
  {
    VAR
      DebuggerCallstack@1005 : Record 2000000101;
      UserPersonalization@1009 : Record 2000000073;
      DebuggerManagement@1012 : Codeunit 9500;
      BreakEnabled@1004 : Boolean INDATASET;
      BreakpointHit@1002 : Boolean INDATASET;
      BreakOnError@1000 : Boolean INDATASET;
      Text002Msg@1007 : TextConst '@@@=Message shown when Break On Error occurs. Include the original error message.;DAN=Afbryd ved fejlmeddelelse:\ \%1;ENU=Break On Error Message:\ \%1';
      BreakOnRecordChanges@1003 : Boolean INDATASET;
      SkipCodeunit1@1010 : Boolean;
      DataCaption@1001 : Text[100];
      ShowLastErrorEnabled@1006 : Boolean INDATASET;
      Text003Cap@1011 : TextConst '@@@=DataCaption when debugger is broken in application code. Example: Codeunit 1:  Application Management;DAN=%1 %2 : %3;ENU=%1 %2 : %3';
      Text004Cap@1013 : TextConst '@@@=DataCaption when waiting for break;DAN=Venter p† afbrydelse...;ENU=Waiting for break...';
      SetAttachedSession@1008 : Boolean;
      Text005Msg@1014 : TextConst 'DAN=Sidste fejlmeddelelse:\ \%1;ENU=Last Error Message:\ \%1';
      Text007Msg@1016 : TextConst 'DAN=Den session, der er foretaget fejlfinding af, er lukket. Fejlfindingssiden lukkes.;ENU=The session that was being debugged has closed. The Debugger Page will close.';
      StartTime@1015 : DateTime;
      FinishTime@1017 : DateTime;

    LOCAL PROCEDURE SaveConfiguration@1();
    BEGIN
      IF UserPersonalization.GET(USERSECURITYID) THEN BEGIN
        UserPersonalization."Debugger Break On Error" := BreakOnError;
        UserPersonalization."Debugger Break On Rec Changes" := BreakOnRecordChanges;
        UserPersonalization."Debugger Skip System Triggers" := SkipCodeunit1;
        UserPersonalization.MODIFY;
      END;
    END;

    LOCAL PROCEDURE WaitingForBreak@3();
    BEGIN
      BreakEnabled := TRUE;
      CurrPage.Callstack.PAGE.ResetCallstackToTop;
    END;

    BEGIN
    END.
  }
}

