OBJECT Page 9508 Debugger Variable List
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
    CaptionML=[DAN=Debugger-variabeloversigt;
               ENU=Debugger Variable List];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    LinksAllowed=No;
    SourceTable=Table2000000102;
    PageType=List;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Overv†g;
                                ENU=New,Process,Report,Watch];
    ActionList=ACTIONS
    {
      { 6       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 9       ;1   ;Separator  }
      { 7       ;1   ;Action    ;
                      Name=Add Watch;
                      ShortCutKey=Ctrl+Insert;
                      CaptionML=[DAN=Tilf›j overv†gning;
                                 ENU=Add Watch];
                      ToolTipML=[DAN=Tilf›j den valgte variabel til overv†gningsoversigten.;
                                 ENU=Add the selected variable to the watch list.];
                      ApplicationArea=#All;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=AddWatch;
                      PromotedCategory=Category4;
                      OnAction=VAR
                                 DebuggerManagement@1002 : Codeunit 9500;
                               BEGIN
                                 DebuggerManagement.AddWatch(Path,FALSE);
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
                IndentationColumnName=Indentation;
                ShowAsTree=Yes;
                GroupType=Repeater }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Navn;
                           ENU=Name];
                ToolTipML=[DAN=Angiver navnet p† den variabel, som er blevet f›jet til debugger-variabeloversigten.;
                           ENU=Specifies the name of the variable that has been added to the Debugger Variable List.];
                ApplicationArea=#All;
                SourceExpr=Name }

    { 4   ;2   ;Field     ;
                CaptionML=[DAN=V‘rdi;
                           ENU=Value];
                ToolTipML=[DAN=Angiver v‘rdien for den variabel, som er blevet f›jet til debugger-variabeloversigten.;
                           ENU=Specifies the value of the variable that has been added to the Debugger Variable List.];
                ApplicationArea=#All;
                SourceExpr=Value }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Type;
                           ENU=Type];
                ToolTipML=[DAN=Angiver typen for den variabel, som er blevet f›jet til debugger-variabeloversigten.;
                           ENU=Specifies the type of the variable that has been added to the Debugger Variable List.];
                ApplicationArea=#All;
                SourceExpr=Type }

  }
  CODE
  {

    BEGIN
    END.
  }
}

