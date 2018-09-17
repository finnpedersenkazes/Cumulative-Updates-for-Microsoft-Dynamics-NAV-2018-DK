OBJECT Page 954 Manager Time Sheet by Job
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Leders timeseddel efter sag;
               ENU=Manager Time Sheet by Job];
    InsertAllowed=No;
    DeleteAllowed=No;
    SourceTable=Table951;
    SourceTableView=WHERE(Type=CONST(Job));
    PageType=Worksheet;
    AutoSplitKey=Yes;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger,Vis;
                                ENU=New,Process,Report,Navigate,Show];
    OnOpenPage=BEGIN
                 FindPeriod(SetWanted::Initial);
               END;

    OnAfterGetRecord=BEGIN
                       AfterGetCurrentRecord;
                     END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 20      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Timeseddel;
                                 ENU=&Time Sheet] }
      { 7       ;2   ;Action    ;
                      ShortCutKey=Ctrl+PgUp;
                      CaptionML=[DAN=&Forrige periode;
                                 ENU=&Previous Period];
                      ToolTipML=[DAN=FÜ vist oplysningerne baseret pÜ den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen fõr.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindPeriod(SetWanted::Previous);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      ShortCutKey=Ctrl+PgDn;
                      CaptionML=[DAN=&Nëste periode;
                                 ENU=&Next Period];
                      ToolTipML=[DAN=FÜ vist oplysninger for den nëste periode.;
                                 ENU=View information for the next period.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindPeriod(SetWanted::Next);
                               END;
                                }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 12      ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 955;
                      RunPageLink=No.=FIELD(Time Sheet No.),
                                  Time Sheet Line No.=FIELD(Line No.);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5 }
      { 6       ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Bogfõrer p&oster;
                                 ENU=Posting E&ntries];
                      ToolTipML=[DAN=Vis de ressourceposter, der er bogfõrt i forbindelse med timesedlen.;
                                 ENU=View the resource ledger entries that have been posted in connection with the.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=PostingEntries;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 TimeSheetMgt.ShowPostingEntries("Time Sheet No.","Line No.");
                               END;
                                }
      { 13      ;2   ;Action    ;
                      ShortCutKey=Shift+F7;
                      CaptionML=[DAN=Aktivitets&detaljer;
                                 ENU=Activity &Details];
                      ToolTipML=[DAN=Vis antallet af timer for hver timeseddelstatus.;
                                 ENU=View the quantity of hours for each time sheet status.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=View;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 ShowLineDetails(TRUE);
                               END;
                                }
      { 1900000004;0 ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 33      ;1   ;ActionGroup;
                      CaptionML=[DAN=Fu&nktion;
                                 ENU=F&unctions];
                      Image=Action }
      { 37      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F9;
                      CaptionML=[DAN=Go&dkend;
                                 ENU=&Approve];
                      ToolTipML=[DAN=Godkend linjerne pÜ timesedlen. Vëlg Alle for at godkende alle linjer. Vëlg Markeret for kun at godkende de markerede linjer.;
                                 ENU=Approve the lines on the time sheet. Choose All to approve all lines. Choose Selected to approve only selected lines.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Approve;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Approve;
                               END;
                                }
      { 46      ;2   ;Action    ;
                      CaptionML=[DAN=A&fvis;
                                 ENU=&Reject];
                      ToolTipML=[DAN=Afvis for at godkende linjerne pÜ timesedlen. Vëlg Alle for at afvise alle linjer. Vëlg Markeret for kun at afvise de markerede linjer.;
                                 ENU=Reject to approve the lines on the time sheet. Choose All to reject all lines. Choose Selected to reject only selected lines.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=Reject;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Reject;
                               END;
                                }
      { 14      ;2   ;Action    ;
                      CaptionML=[DAN=&èbn igen;
                                 ENU=Re&open];
                      ToolTipML=[DAN=èbn timesedlen igen for at ëndre den.;
                                 ENU=Reopen the time sheet to change it.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=ReOpen;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 Reopen;
                               END;
                                }
      { 47      ;2   ;Separator  }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 10  ;1   ;Group     ;
                GroupType=Group }

    { 3   ;2   ;Field     ;
                CaptionML=[DAN=Startdato;
                           ENU=Starting Date];
                ToolTipML=[DAN=Angiver den dato, som rapporten eller kõrslen behandler oplysninger fra.;
                           ENU=Specifies the date from which the report or batch job processes information.];
                ApplicationArea=#Jobs;
                SourceExpr=StartingDate;
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                CaptionML=[DAN=Slutdato;
                           ENU=Ending Date];
                ToolTipML=[DAN=Angiver den dato, som rapporten eller kõrslen behandler oplysninger frem til.;
                           ENU=Specifies the date to which the report or batch job processes information.];
                ApplicationArea=#Jobs;
                SourceExpr=EndingDate;
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den sag, som er knyttet til timeseddellinjen.;
                           ENU=Specifies the number for the job that is associated with the time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No.";
                Visible=FALSE;
                Editable=FALSE }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No.";
                Visible=FALSE;
                Editable=FALSE }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af timeseddellinjen.;
                           ENU=Specifies a description of the time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr=Description;
                Editable=FALSE;
                OnAssistEdit=BEGIN
                               ShowLineDetails(TRUE);
                               CurrPage.UPDATE;
                             END;
                              }

    { 18  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code";
                Visible=FALSE;
                Editable=WorkTypeCodeAllowEdit;
                OnValidate=BEGIN
                             TESTFIELD(Status,Status::Submitted);
                           END;
                            }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om det forbrug, du bogfõrer, kan faktureres.;
                           ENU=Specifies if the usage that you are posting is chargeable.];
                ApplicationArea=#Jobs;
                SourceExpr=Chargeable;
                Visible=FALSE;
                Editable=ChargeableAllowEdit;
                OnValidate=BEGIN
                             TESTFIELD(Status,Status::Submitted);
                           END;
                            }

    { 11  ;2   ;Field     ;
                Name=Field1;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[1];
                CaptionClass='3,' + ColumnCaption[1];
                Editable=FALSE }

    { 15  ;2   ;Field     ;
                Name=Field2;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[2];
                CaptionClass='3,' + ColumnCaption[2];
                Editable=FALSE }

    { 17  ;2   ;Field     ;
                Name=Field3;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[3];
                CaptionClass='3,' + ColumnCaption[3];
                Editable=FALSE }

    { 19  ;2   ;Field     ;
                Name=Field4;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[4];
                CaptionClass='3,' + ColumnCaption[4];
                Editable=FALSE }

    { 21  ;2   ;Field     ;
                Name=Field5;
                Width=6;
                ApplicationArea=#Jobs;
                DecimalPlaces=0:2;
                BlankZero=Yes;
                SourceExpr=CellData[5];
                CaptionClass='3,' + ColumnCaption[5];
                Editable=FALSE }

    { 25  ;2   ;Field     ;
                Name=Field6;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[6];
                CaptionClass='3,' + ColumnCaption[6];
                Visible=FALSE;
                Editable=FALSE }

    { 27  ;2   ;Field     ;
                Name=Field7;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[7];
                CaptionClass='3,' + ColumnCaption[7];
                Visible=FALSE;
                Editable=FALSE }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om status for en timeseddellinje.;
                           ENU=Specifies information about the status of a time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr=Status }

    { 16  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det samlede antal timer, der er angivet pÜ en timeseddel.;
                           ENU=Specifies the total number of hours that have been entered on a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Quantity";
                Visible=FALSE }

  }
  CODE
  {
    VAR
      ResourcesSetup@1013 : Record 314;
      TimeSheetDetail@1003 : Record 952;
      ColumnRecords@1004 : ARRAY [32] OF Record 2000000007;
      TimeSheetMgt@1007 : Codeunit 950;
      TimeSheetApprovalMgt@1010 : Codeunit 951;
      NoOfColumns@1002 : Integer;
      CellData@1001 : ARRAY [32] OF Decimal;
      ColumnCaption@1000 : ARRAY [32] OF Text[1024];
      SetWanted@1009 : 'Initial,Previous,Next';
      StartingDate@1011 : Date;
      EndingDate@1012 : Date;
      WorkTypeCodeAllowEdit@1006 : Boolean;
      ChargeableAllowEdit@1005 : Boolean;

    [Internal]
    PROCEDURE SetColumns@11();
    VAR
      Calendar@1003 : Record 2000000007;
    BEGIN
      CLEAR(ColumnCaption);
      CLEAR(ColumnRecords);
      CLEAR(Calendar);
      CLEAR(NoOfColumns);

      Calendar.SETRANGE("Period Type",Calendar."Period Type"::Date);
      Calendar.SETRANGE("Period Start",StartingDate,EndingDate);
      IF Calendar.FINDSET THEN
        REPEAT
          NoOfColumns += 1;
          ColumnRecords[NoOfColumns]."Period Start" := Calendar."Period Start";
          ColumnCaption[NoOfColumns] := TimeSheetMgt.FormatDate(Calendar."Period Start",1);
        UNTIL Calendar.NEXT = 0;
    END;

    LOCAL PROCEDURE AfterGetCurrentRecord@8();
    VAR
      i@1000 : Integer;
    BEGIN
      i := 0;
      WHILE i < NoOfColumns DO BEGIN
        i := i + 1;
        IF ("Line No." <> 0) AND TimeSheetDetail.GET(
             "Time Sheet No.",
             "Line No.",
             ColumnRecords[i]."Period Start")
        THEN
          CellData[i] := TimeSheetDetail.Quantity
        ELSE
          CellData[i] := 0;
      END;
      WorkTypeCodeAllowEdit := GetAllowEdit(FIELDNO("Work Type Code"),TRUE);
      ChargeableAllowEdit := GetAllowEdit(FIELDNO(Chargeable),TRUE);
    END;

    LOCAL PROCEDURE FindPeriod@10(Which@1003 : 'Initial,Previous,Next');
    BEGIN
      ResourcesSetup.GET;
      CASE Which OF
        Which::Initial:
          IF DATE2DWY(WORKDATE,1) = ResourcesSetup."Time Sheet First Weekday" + 1 THEN
            StartingDate := WORKDATE
          ELSE
            StartingDate := CALCDATE(STRSUBSTNO('<WD%1-7D>',ResourcesSetup."Time Sheet First Weekday" + 1),WORKDATE);
        Which::Previous:
          StartingDate := CALCDATE('<-1W>',StartingDate);
        Which::Next:
          StartingDate := CALCDATE('<1W>',StartingDate);
      END;
      EndingDate := CALCDATE('<1W>',StartingDate) - 1;
      FILTERGROUP(2);
      SETRANGE("Time Sheet Starting Date",StartingDate,EndingDate);
      SETRANGE("Approver ID",USERID);
      FILTERGROUP(0);
      SetColumns;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE Process@1(Action@1000 : 'Approve Selected,Approve All,Reopen Selected,Reopen All,Reject Selected,Reject All');
    VAR
      TimeSheetLine@1001 : Record 951;
      ActionType@1002 : 'Approve,Reopen,Reject';
    BEGIN
      CurrPage.SAVERECORD;
      CASE Action OF
        Action::"Approve All",
        Action::"Reject All":
          FilterAllLines(TimeSheetLine,ActionType::Approve);
        Action::"Reopen All":
          FilterAllLines(TimeSheetLine,ActionType::Reopen);
        ELSE
          CurrPage.SETSELECTIONFILTER(TimeSheetLine);
      END;
      IF TimeSheetLine.FINDSET THEN
        REPEAT
          CASE Action OF
            Action::"Approve Selected",
            Action::"Approve All":
              TimeSheetApprovalMgt.Approve(TimeSheetLine);
            Action::"Reopen Selected",
            Action::"Reopen All":
              TimeSheetApprovalMgt.ReopenApproved(TimeSheetLine);
            Action::"Reject Selected",
            Action::"Reject All":
              TimeSheetApprovalMgt.Reject(TimeSheetLine);
          END;
        UNTIL TimeSheetLine.NEXT = 0;
      CurrPage.UPDATE(FALSE);
    END;

    LOCAL PROCEDURE Approve@2();
    VAR
      Action@1001 : 'Approve Selected,Approve All,Reopen Selected,Reopen All,Reject Selected,Reject All';
      ActionType@1002 : 'Approve,Reopen,Reject';
    BEGIN
      CASE ShowDialog(ActionType::Approve) OF
        1:
          Process(Action::"Approve All");
        2:
          Process(Action::"Approve Selected");
      END;
    END;

    LOCAL PROCEDURE Reopen@14();
    VAR
      ActionType@1002 : 'Approve,Reopen,Reject';
      Action@1001 : 'Approve Selected,Approve All,Reopen Selected,Reopen All,Reject Selected,Reject All';
    BEGIN
      CASE ShowDialog(ActionType::Reopen) OF
        1:
          Process(Action::"Reopen All");
        2:
          Process(Action::"Reopen Selected");
      END;
    END;

    LOCAL PROCEDURE Reject@3();
    VAR
      ActionType@1002 : 'Approve,Reopen,Reject';
      Action@1001 : 'Approve Selected,Approve All,Reopen Selected,Reopen All,Reject Selected,Reject All';
    BEGIN
      CASE ShowDialog(ActionType::Reject) OF
        1:
          Process(Action::"Reject All");
        2:
          Process(Action::"Reject Selected");
      END;
    END;

    LOCAL PROCEDURE GetDialogText@16(ActionType@1000 : 'Approve,Reopen,Reject') : Text[100];
    VAR
      TimeSheetLine@1003 : Record 951;
    BEGIN
      FilterAllLines(TimeSheetLine,ActionType);
      EXIT(TimeSheetApprovalMgt.GetManagerTimeSheetDialogText(ActionType,TimeSheetLine.COUNT));
    END;

    LOCAL PROCEDURE FilterAllLines@22(VAR TimeSheetLine@1000 : Record 951;ActionType@1001 : 'Approve,Reopen,Reject');
    BEGIN
      TimeSheetLine.COPYFILTERS(Rec);
      TimeSheetLine.FILTERGROUP(2);
      TimeSheetLine.SETRANGE("Time Sheet Starting Date",StartingDate,EndingDate);
      TimeSheetLine.SETRANGE("Approver ID",USERID);
      TimeSheetLine.SETRANGE(Type,TimeSheetLine.Type::Job);
      TimeSheetLine.FILTERGROUP(0);
      CASE ActionType OF
        ActionType::Approve,
        ActionType::Reject:
          TimeSheetLine.SETRANGE(Status,TimeSheetLine.Status::Submitted);
        ActionType::Reopen:
          TimeSheetLine.SETRANGE(Status,TimeSheetLine.Status::Approved);
      END;
    END;

    LOCAL PROCEDURE ShowDialog@4(ActionType@1000 : 'Approve,Reopen,Reject') : Integer;
    BEGIN
      EXIT(STRMENU(GetDialogText(ActionType),1,TimeSheetApprovalMgt.GetManagerTimeSheetDialogInstruction(ActionType)));
    END;

    BEGIN
    END.
  }
}

