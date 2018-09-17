OBJECT Page 681 Report Inbox Part
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
    CaptionML=[DAN=Rapportindbakke;
               ENU=Report Inbox];
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table477;
    SourceTableView=SORTING(User ID,Created Date-Time)
                    ORDER(Descending);
    PageType=ListPart;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 SETRANGE("User ID",USERID);
                 SETAUTOCALCFIELDS;
                 ShowAll := TRUE;
                 UpdateVisibility;
                 AddInReady := FALSE;
               END;

    OnFindRecord=BEGIN
                   ActionsEnabled := NOT ISEMPTY;
                   EXIT(FIND(Which));
                 END;

    OnQueryClosePage=BEGIN
                       IF AddInReady THEN
                         CurrPage.PingPong.Stop;
                       EXIT(TRUE);
                     END;

    ActionList=ACTIONS
    {
      { 7       ;    ;ActionContainer;
                      CaptionML=[DAN=Rapport;
                                 ENU=Report];
                      ActionContainerType=ActionItems }
      { 8       ;1   ;Action    ;
                      Name=Show;
                      ShortCutKey=Return;
                      CaptionML=[DAN=Vis;
                                 ENU=Show];
                      ToolTipML=[DAN=èbn rapportindbakke.;
                                 ENU=Open your report inbox.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=ActionsEnabled;
                      Image=Report;
                      OnAction=BEGIN
                                 ShowReport;
                                 CurrPage.UPDATE;
                               END;
                                }
      { 11      ;1   ;Separator  }
      { 12      ;1   ;Action    ;
                      Name=Unread;
                      CaptionML=[DAN=Ulëste rapporter;
                                 ENU=Unread Reports];
                      ToolTipML=[DAN=Vis kun ulëste rapporter i din indbakke.;
                                 ENU=Show only unread reports in your inbox.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=ShowAll;
                      Image=FilterLines;
                      OnAction=BEGIN
                                 ShowAll := FALSE;
                                 UpdateVisibility;
                               END;
                                }
      { 13      ;1   ;Action    ;
                      Name=All;
                      CaptionML=[DAN=Alle rapporter;
                                 ENU=All Reports];
                      ToolTipML=[DAN=Vis alle rapporter i din indbakke.;
                                 ENU=View all reports in your inbox.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=NOT ShowAll;
                      Image=AllLines;
                      OnAction=BEGIN
                                 ShowAll := TRUE;
                                 UpdateVisibility;
                               END;
                                }
      { 14      ;1   ;Separator  }
      { 9       ;1   ;Action    ;
                      Name=Delete;
                      CaptionML=[DAN=Slet;
                                 ENU=Delete];
                      ToolTipML=[DAN=Slet recorden.;
                                 ENU=Delete the record.];
                      ApplicationArea=#Basic,#Suite;
                      Enabled=ActionsEnabled;
                      Image=Delete;
                      OnAction=VAR
                                 ReportInbox@1000 : Record 477;
                               BEGIN
                                 CurrPage.SETSELECTIONFILTER(ReportInbox);
                                 ReportInbox.DELETEALL;
                                 UpdateVisibility;
                               END;
                                }
      { 18      ;1   ;Separator  }
      { 19      ;1   ;Action    ;
                      Name=ShowQueue;
                      CaptionML=[DAN=Vis kõ;
                                 ENU=Show Queue];
                      ToolTipML=[DAN=Vis planlagte rapporter.;
                                 ENU=Show scheduled reports.];
                      ApplicationArea=#Basic,#Suite;
                      Image=List;
                      OnAction=VAR
                                 JobQueueEntry@1000 : Record 472;
                               BEGIN
                                 JobQueueEntry.FILTERGROUP(2);
                                 JobQueueEntry.SETRANGE("User ID",USERID);
                                 JobQueueEntry.FILTERGROUP(0);
                                 PAGE.RUN(PAGE::"Job Queue Entries",JobQueueEntry);
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
                ToolTipML=[DAN=Angiver id'et for den bruger, der har bogfõrt posten, der skal bruges, f.eks. i ëndringsloggen.;
                           ENU=Specifies the ID of the user who posted the entry, to be used, for example, in the change log.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="User ID";
                Visible=false;
                Style=Strong;
                StyleExpr=NOT Read }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver dato og tidspunkt, hvor den planlagte rapport blev behandlet i sagskõen.;
                           ENU=Specifies the date and time that the scheduled report was processed from the job queue.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Created Date-Time";
                Style=Strong;
                StyleExpr=NOT Read }

    { 5   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver rapportens objekt-id.;
                           ENU=Specifies the object ID of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report ID";
                Visible=false;
                Style=Strong;
                StyleExpr=NOT Read }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver navnet pÜ rapporten.;
                           ENU=Specifies the name of the report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Report Name";
                Visible=FALSE;
                Style=Strong;
                StyleExpr=NOT Read;
                OnDrillDown=BEGIN
                              ShowReport;
                              CurrPage.UPDATE;
                            END;
                             }

    { 15  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver beskrivelsen pÜ den planlagte rapport, der blev behandlet i sagskõen.;
                           ENU=Specifies the description of the scheduled report that was processed from the job queue.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr=Description;
                Style=Strong;
                StyleExpr=NOT Read;
                OnDrillDown=BEGIN
                              ShowReport;
                              CurrPage.UPDATE;
                            END;
                             }

    { 10  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver resultattypen pÜ den planlagte rapport.;
                           ENU=Specifies the output type of the scheduled report.];
                ApplicationArea=#Basic,#Suite;
                SourceExpr="Output Type";
                Style=Strong;
                StyleExpr=NOT Read }

    { 16  ;1   ;Group     ;
                GroupType=Group }

    { 17  ;2   ;Field     ;
                Name=PingPong;
                ApplicationArea=#Basic,#Suite;
                ControlAddIn=[Microsoft.Dynamics.Nav.Client.PingPong;PublicKeyToken=31bf3856ad364e35] }

  }
  CODE
  {
    VAR
      ShowAll@1000 : Boolean;
      PrevNumberOfRecords@1001 : Integer;
      AddInReady@1002 : Boolean;
      ActionsEnabled@1003 : Boolean;

    LOCAL PROCEDURE UpdateVisibility@1();
    BEGIN
      IF ShowAll THEN
        SETRANGE(Read)
      ELSE
        SETRANGE(Read,FALSE);
      ActionsEnabled := FINDFIRST;
      CurrPage.UPDATE(FALSE);
    END;

    EVENT PingPong@-17::AddInReady@2();
    BEGIN
      AddInReady := TRUE;
      PrevNumberOfRecords := COUNT;
      CurrPage.PingPong.Ping(10000);
    END;

    EVENT PingPong@-17::Pong@3();
    VAR
      CurrNumberOfRecords@1000 : Integer;
    BEGIN
      CurrNumberOfRecords := COUNT;
      IF PrevNumberOfRecords <> CurrNumberOfRecords THEN
        CurrPage.UPDATE(FALSE);
      PrevNumberOfRecords := CurrNumberOfRecords;
      CurrPage.PingPong.Ping(10000);
    END;

    BEGIN
    END.
  }
}

