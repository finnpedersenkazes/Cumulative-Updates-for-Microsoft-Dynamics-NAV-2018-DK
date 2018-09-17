OBJECT Page 1170 User Task List
{
  OBJECT-PROPERTIES
  {
    Date=25-05-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.22292;
  }
  PROPERTIES
  {
    Editable=Yes;
    CaptionML=[DAN=Brugeropgaver;
               ENU=User Tasks];
    InsertAllowed=No;
    DeleteAllowed=Yes;
    ModifyAllowed=No;
    SourceTable=Table1170;
    DelayedInsert=Yes;
    PageType=List;
    CardPageID=User Task Card;
    RefreshOnActivate=Yes;
    OnAfterGetRecord=BEGIN
                       StyleTxt := SetStyle;
                     END;

    ODataKeyFields=ID;
    ActionList=ACTIONS
    {
      { 8       ;    ;ActionContainer;
                      Name=UserTaskListActions;
                      ActionContainerType=NewDocumentItems }
      { 14      ;1   ;Action    ;
                      Name=Mark Complete;
                      CaptionML=[DAN=Mark as Completed;
                                 ENU=Mark as Completed];
                      ToolTipML=[DAN=Indicate that the task is completed. The % Complete field is set to 100.;
                                 ENU=Indicate that the task is completed. The % Complete field is set to 100.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=CheckList;
                      PromotedCategory=Process;
                      PromotedOnly=Yes;
                      OnAction=VAR
                                 UserTask@1000 : Record 1170;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(UserTask);
                                 IF UserTask.FINDSET(TRUE) THEN
                                   REPEAT
                                     UserTask.SetCompleted;
                                     UserTask.MODIFY;
                                   UNTIL UserTask.NEXT = 0;
                               END;
                                }
      { 15      ;1   ;Action    ;
                      Name=Go To Task Item;
                      CaptionML=[DAN=GÜ til opgaveelementet;
                                 ENU=Go To Task Item];
                      ToolTipML=[DAN=èbner den side eller rapport, som er knyttet til denne opgave.;
                                 ENU=Open the page or report that is associated with this task.];
                      ApplicationArea=#Basic,#Suite;
                      Promoted=Yes;
                      Image=Navigate;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 RunReportOrPageLink;
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
                ToolTipML=[DAN=Angiver opgavens titel.;
                           ENU=Specifies the title of the task.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Title }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr opgaven skal vëre afsluttet.;
                           ENU=Specifies when the task must be completed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Due DateTime";
                StyleExpr=StyleTxt }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens prioritet.;
                           ENU=Specifies the priority of the task.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Priority }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver opgavens status.;
                           ENU=Specifies the progress of the task.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Percent Complete";
                StyleExpr=StyleTxt }

    { 7   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvem opgaven er blevet tildelt.;
                           ENU=Specifies who the task is assigned to.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Assigned To User Name" }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr opgaven blev oprettet.;
                           ENU=Specifies when the task was created.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created DateTime";
                Visible=FALSE }

    { 9   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr opgaven blev afsluttet.;
                           ENU=Specifies when the task was completed.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Completed DateTime";
                Visible=FALSE }

    { 12  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvornÜr opgaven skal begynde.;
                           ENU=Specifies when the task must start.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Start DateTime";
                Visible=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvem der har oprettet opgaven.;
                           ENU=Specifies who created the task.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created By User Name";
                Visible=FALSE }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvem der har afsluttet opgaven.;
                           ENU=Specifies who completed the task.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Completed By User Name";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      StyleTxt@1000 : Text;

    PROCEDURE SetFiltersForUserTasksCue@1();
    VAR
      OriginalFilterGroup@1000 : Integer;
    BEGIN
      OriginalFilterGroup := FILTERGROUP;
      FILTERGROUP(25);
      SETFILTER("Percent Complete",'<>100');
      SETRANGE("Assigned To",USERSECURITYID);
      FILTERGROUP(OriginalFilterGroup);
    END;

    LOCAL PROCEDURE RunReportOrPageLink@2();
    VAR
      AllObjWithCaption@1000 : Record 2000000058;
    BEGIN
      IF ("Object Type" = 0) OR ("Object ID" = 0) THEN
        EXIT;
      IF "Object Type" = AllObjWithCaption."Object Type"::Page THEN
        PAGE.RUN("Object ID")
      ELSE
        REPORT.RUN("Object ID");
    END;

    [ServiceEnabled]
    [External]
    PROCEDURE SetComplete@4();
    BEGIN
      SetCompleted;
      MODIFY;
    END;

    BEGIN
    END.
  }
}

