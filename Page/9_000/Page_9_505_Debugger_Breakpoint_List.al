OBJECT Page 9505 Debugger Breakpoint List
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Debugger-breakpointoversigt;
               ENU=Debugger Breakpoint List];
    LinksAllowed=No;
    SourceTable=Table2000000100;
    DelayedInsert=Yes;
    SourceTableView=SORTING(Object Type,Object ID,Line No.,Column No.)
                    ORDER(Ascending);
    PageType=List;
    RefreshOnActivate=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Betingelser for afbrydelse;
                                ENU=New,Process,Report,Conditions For Break];
    ActionList=ACTIONS
    {
      { 13      ;    ;ActionContainer;
                      Name=Breakpoint Actions;
                      ActionContainerType=ActionItems }
      { 3       ;1   ;Separator  }
      { 19      ;1   ;ActionGroup;
                      Name=Breakpoint;
                      CaptionML=[DAN=Breakpoint;
                                 ENU=Breakpoint] }
      { 4       ;2   ;Action    ;
                      Name=Enable;
                      CaptionML=[DAN=Aktiver;
                                 ENU=Enable];
                      ToolTipML=[DAN=Aktiver de valgte breakpoints.;
                                 ENU=Enable the selected breakpoints.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=EnableBreakpoint;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DebuggerBreakpoint@1000 : Record 2000000100;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(DebuggerBreakpoint);
                                 DebuggerBreakpoint.MODIFYALL(Enabled,TRUE,TRUE);
                               END;
                                }
      { 8       ;2   ;Action    ;
                      Name=Disable;
                      CaptionML=[DAN=Deaktiver;
                                 ENU=Disable];
                      ToolTipML=[DAN=Deaktiver de valgte breakpoints.;
                                 ENU=Disable the selected breakpoints.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=DisableBreakpoint;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DebuggerBreakpoint@1000 : Record 2000000100;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(DebuggerBreakpoint);
                                 DebuggerBreakpoint.MODIFYALL(Enabled,FALSE,TRUE);
                               END;
                                }
      { 10      ;2   ;Action    ;
                      Name=Enable All;
                      CaptionML=[DAN=Aktiver alle;
                                 ENU=Enable All];
                      ToolTipML=[DAN=Aktiver alle breakpoints i oversigten over breakpoints.;
                                 ENU=Enable all breakpoints in the breakpoint list.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=EnableAllBreakpoints;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MODIFYALL(Enabled,TRUE,TRUE);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      Name=Disable All;
                      CaptionML=[DAN=Deaktiver alle;
                                 ENU=Disable All];
                      ToolTipML=[DAN=Deaktiver alle breakpoints i oversigten over breakpoints.;
                                 ENU=Disable all breakpoints in the breakpoint list.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=DisableAllBreakpoints;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 MODIFYALL(Enabled,FALSE,TRUE);
                               END;
                                }
      { 11      ;2   ;Action    ;
                      Name=Delete All;
                      CaptionML=[DAN=Slet alle;
                                 ENU=Delete All];
                      ToolTipML=[DAN=Slet alle breakpoints i oversigten over breakpoints.;
                                 ENU=Delete all breakpoints in the breakpoint list.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      Image=DeleteAllBreakpoints;
                      PromotedCategory=Process;
                      OnAction=VAR
                                 DebuggerBreakpoint@1001 : Record 2000000100;
                               BEGIN
                                 IF NOT CONFIRM(Text000,FALSE) THEN
                                   EXIT;

                                 DebuggerBreakpoint.DELETEALL(TRUE);
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

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Objekttype;
                           ENU=Object Type];
                ToolTipML=[DAN=Angiver typen for det objekt, hvor breakpointet er angivet.;
                           ENU=Specifies the type of the object where the breakpoint is set.];
                ApplicationArea=#All;
                SourceExpr="Object Type" }

    { 6   ;2   ;Field     ;
                CaptionML=[DAN=Objekt-id;
                           ENU=Object ID];
                ToolTipML=[DAN=Angiver id'et p† det objekt, som breakpointet er angivet p†.;
                           ENU=Specifies the ID of the object on which the breakpoint is set.];
                ApplicationArea=#All;
                SourceExpr="Object ID" }

    { 12  ;2   ;Field     ;
                CaptionML=[DAN=Objektnavn;
                           ENU=Object Name];
                ToolTipML=[DAN=Angiver navnet p† det objekt, som breakpointet er angivet i.;
                           ENU=Specifies the name of the object in which the breakpoint is set.];
                ApplicationArea=#All;
                SourceExpr="Object Name";
                Editable=FALSE }

    { 7   ;2   ;Field     ;
                CaptionML=[DAN=Linjenr.;
                           ENU=Line No.];
                ToolTipML=[DAN=Angiver kodelinjen i objektet, som breakpointet er indstillet p†. Dette er det absolutte linjenummer for kodelinjer i objektet.;
                           ENU=Specifies the line of code within the object on which the breakpoint is set. This is the absolute line number for lines of code in the object.];
                ApplicationArea=#All;
                SourceExpr="Line No." }

    { 21  ;2   ;Field     ;
                CaptionML=[DAN=Funktionsnavn;
                           ENU=Function Name];
                ToolTipML=[DAN=Angiver navnet p† funktionen.;
                           ENU=Specifies the name of the function.];
                ApplicationArea=#All;
                SourceExpr="Function Name";
                Editable=FALSE }

    { 14  ;2   ;Field     ;
                CaptionML=[DAN=Aktiveret;
                           ENU=Enabled];
                ToolTipML=[DAN=Angiver, om breakpointet er aktiveret.;
                           ENU=Specifies if the breakpoint is enabled.];
                ApplicationArea=#All;
                SourceExpr=Enabled }

    { 18  ;2   ;Field     ;
                CaptionML=[DAN=Betingelse;
                           ENU=Condition];
                ToolTipML=[DAN=Angiver den betingelse, der er angivet p† et breakpoint.;
                           ENU=Specifies the condition that is set on the breakpoint.];
                ApplicationArea=#All;
                SourceExpr=Condition }

  }
  CODE
  {
    VAR
      Text000@1000 : TextConst '@@@=Asked when choosing the Delete All action for breakpoints.;DAN=Er du sikker p†, at alle breakpoints skal slettes?;ENU=Are you sure that you want to delete all breakpoints?';

    BEGIN
    END.
  }
}

