OBJECT Page 959 Time Sheet Archive
{
  OBJECT-PROPERTIES
  {
    Date=27-07-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.23572;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Arkiv for timesedler;
               ENU=Time Sheet Archive];
    SaveValues=Yes;
    InsertAllowed=No;
    DeleteAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table955;
    DataCaptionFields=Time Sheet No.;
    PageType=Worksheet;
    PromotedActionCategoriesML=[DAN=Ny,Behandl,Rapport,Naviger,Vis;
                                ENU=New,Process,Report,Navigate,Show];
    OnOpenPage=BEGIN
                 IF "Time Sheet No." <> '' THEN
                   CurrTimeSheetNo := "Time Sheet No."
                 ELSE
                   CurrTimeSheetNo :=
                     TimeSheetHeaderArchive.FindLastTimeSheetArchiveNo(
                       TimeSheetHeaderArchive.FIELDNO("Owner User ID"));

                 TimeSheetMgt.SetTimeSheetArchiveNo(CurrTimeSheetNo,Rec);
                 UpdateControls;
               END;

    OnAfterGetRecord=BEGIN
                       AfterGetCurrentRecord;
                     END;

    OnNewRecord=BEGIN
                  AfterGetCurrentRecord;
                END;

    ActionList=ACTIONS
    {
      { 1900000003;0 ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 12      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Timeseddel;
                                 ENU=&Time Sheet];
                      ActionContainerType=NewDocumentItems;
                      Image=Timesheet }
      { 7       ;2   ;Action    ;
                      ShortCutKey=Ctrl+PgUp;
                      CaptionML=[DAN=&Forrige periode;
                                 ENU=&Previous Period];
                      ToolTipML=[DAN=F† vist oplysningerne baseret p† den forrige periode. Hvis du indstiller feltet Vis efter til Dag, skifter datofilteret til dagen f›r.;
                                 ENU=Show the information based on the previous period. If you set the View by field to Day, the date filter changes to the day before.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=PreviousSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindTimeSheet(SetWanted::Previous);
                               END;
                                }
      { 9       ;2   ;Action    ;
                      ShortCutKey=Ctrl+PgDn;
                      CaptionML=[DAN=&N‘ste periode;
                                 ENU=&Next Period];
                      ToolTipML=[DAN=F† vist oplysninger for den n‘ste periode.;
                                 ENU=View information for the next period.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=NextSet;
                      PromotedCategory=Category4;
                      OnAction=BEGIN
                                 FindTimeSheet(SetWanted::Next);
                               END;
                                }
      { 24      ;1   ;ActionGroup;
                      CaptionML=[DAN=&Linje;
                                 ENU=&Line];
                      Image=Line }
      { 28      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Bogf›rer p&oster;
                                 ENU=Posting E&ntries];
                      ToolTipML=[DAN=Vis de ressourceposter, der er bogf›rt i forbindelse med timesedlen.;
                                 ENU=View the resource ledger entries that have been posted in connection with the.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      Image=PostingEntries;
                      PromotedCategory=Category5;
                      OnAction=BEGIN
                                 TimeSheetMgt.ShowPostingEntries("Time Sheet No.","Line No.");
                               END;
                                }
      { 32      ;1   ;ActionGroup;
                      CaptionML=[DAN=Be&m‘rkninger;
                                 ENU=Co&mments];
                      Image=ViewComments }
      { 22      ;2   ;Action    ;
                      Name=TimeSheetComments;
                      CaptionML=[DAN=&Bem‘rkninger til timeseddel;
                                 ENU=&Time Sheet Comments];
                      ToolTipML=[DAN=Vis bem‘rkninger til timesedlen.;
                                 ENU=View comments about the time sheet.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 963;
                      RunPageLink=No.=FIELD(Time Sheet No.),
                                  Time Sheet Line No.=CONST(0);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5 }
      { 18      ;2   ;Action    ;
                      Name=LineComments;
                      CaptionML=[DAN=&Linjebem‘rkninger;
                                 ENU=&Line Comments];
                      ToolTipML=[DAN=Vis eller opret bem‘rkninger.;
                                 ENU=View or create comments.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 963;
                      RunPageLink=No.=FIELD(Time Sheet No.),
                                  Time Sheet Line No.=FIELD(Line No.);
                      Promoted=Yes;
                      Image=ViewComments;
                      PromotedCategory=Category5 }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 26  ;1   ;Group     ;
                GroupType=Group }

    { 10  ;2   ;Field     ;
                CaptionML=[DAN=Timeseddelnr.;
                           ENU=Time Sheet No];
                ToolTipML=[DAN=Angiver nummeret p† timesedlen.;
                           ENU=Specifies the number of the time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr=CurrTimeSheetNo;
                OnValidate=BEGIN
                             TimeSheetHeaderArchive.RESET;
                             TimeSheetMgt.FilterTimeSheetsArchive(TimeSheetHeaderArchive,TimeSheetHeaderArchive.FIELDNO("Owner User ID"));
                             TimeSheetMgt.CheckTimeSheetArchiveNo(TimeSheetHeaderArchive,CurrTimeSheetNo);
                             CurrPage.SAVERECORD;
                             TimeSheetMgt.SetTimeSheetArchiveNo(CurrTimeSheetNo,Rec);
                             UpdateControls;
                           END;

                OnLookup=BEGIN
                           CurrPage.SAVERECORD;
                           TimeSheetMgt.LookupOwnerTimeSheetArchive(CurrTimeSheetNo,Rec,TimeSheetHeaderArchive);
                           UpdateControls;
                         END;
                          }

    { 14  ;2   ;Field     ;
                Name=ResourceNo;
                CaptionML=[DAN=Ressourcenr.;
                           ENU=Resource No.];
                ToolTipML=[DAN=Angiver et nummer til ressourcen.;
                           ENU=Specifies a number for the resource.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeaderArchive."Resource No.";
                Editable=false }

    { 16  ;2   ;Field     ;
                Name=ApproverUserID;
                CaptionML=[DAN=Bruger-id for godkender;
                           ENU=Approver User ID];
                ToolTipML=[DAN=Angiver id'et for timeseddelgodkenderen.;
                           ENU=Specifies the ID of the time sheet approver.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeaderArchive."Approver User ID";
                Editable=FALSE }

    { 3   ;2   ;Field     ;
                Name=StartingDate;
                CaptionML=[DAN=Startdato;
                           ENU=Starting Date];
                ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger fra.;
                           ENU=Specifies the date from which the report or batch job processes information.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeaderArchive."Starting Date";
                Editable=FALSE }

    { 5   ;2   ;Field     ;
                Name=EndingDate;
                CaptionML=[DAN=Slutdato;
                           ENU=Ending Date];
                ToolTipML=[DAN=Angiver den dato, som rapporten eller k›rslen behandler oplysninger frem til.;
                           ENU=Specifies the date to which the report or batch job processes information.];
                ApplicationArea=#Jobs;
                SourceExpr=TimeSheetHeaderArchive."Ending Date";
                Editable=FALSE }

    { 1   ;1   ;Group     ;
                Editable=FALSE;
                GroupType=Repeater }

    { 13  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om den ressourcetype, som timeseddellinjen g‘lder for.;
                           ENU=Specifies information about the type of resource that the time sheet line applies to.];
                ApplicationArea=#Jobs;
                SourceExpr=Type;
                OnValidate=BEGIN
                             AfterGetCurrentRecord;
                             CurrPage.UPDATE(TRUE);
                           END;
                            }

    { 23  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret p† den sag, som er knyttet til timeseddellinjen.;
                           ENU=Specifies the number for the job that is associated with the time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr="Job No." }

    { 29  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret for den relaterede sagsopgave.;
                           ENU=Specifies the number of the related job task.];
                ApplicationArea=#Jobs;
                SourceExpr="Job Task No." }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver en beskrivelse af den arkiverede timeseddellinje.;
                           ENU=Specifies a description of the archived time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr=Description }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver de koder, du kan bruge til at beskrive typen af frav‘r fra arbejde.;
                           ENU=Specifies the codes that you can use to describe the type of absence from work.];
                ApplicationArea=#Jobs;
                SourceExpr="Cause of Absence Code" }

    { 20  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, om den tid, som er knyttet til en arkiveret timeseddel, er fakturerbar.;
                           ENU=Specifies whether the time associated with an archived time sheet is chargeable.];
                ApplicationArea=#Jobs;
                SourceExpr=Chargeable }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver, hvilken arbejdstype ressourcen udlignes med. Priserne opdateres ud fra denne post.;
                           ENU=Specifies which work type the resource applies to. Prices are updated based on this entry.];
                ApplicationArea=#Jobs;
                SourceExpr="Work Type Code" }

    { 30  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det serviceordrenummer, der er tilknyttet en arkiveret timeseddellinje.;
                           ENU=Specifies the service order number that is associated with an archived time sheet line.];
                ApplicationArea=#Jobs;
                SourceExpr="Service Order No." }

    { 31  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver det montageordrenummer, der er tilknyttet timeseddellinjen.;
                           ENU=Specifies the assembly order number that is associated with the time sheet line.];
                ApplicationArea=#Assembly;
                SourceExpr="Assembly Order No." }

    { 8   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver oplysninger om status for en arkiveret timeseddellinje.;
                           ENU=Specifies information about the status of an archived time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr=Status }

    { 11  ;2   ;Field     ;
                Name=Field1;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[1];
                CaptionClass='3,' + ColumnCaption[1] }

    { 15  ;2   ;Field     ;
                Name=Field2;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[2];
                CaptionClass='3,' + ColumnCaption[2] }

    { 17  ;2   ;Field     ;
                Name=Field3;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[3];
                CaptionClass='3,' + ColumnCaption[3] }

    { 19  ;2   ;Field     ;
                Name=Field4;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[4];
                CaptionClass='3,' + ColumnCaption[4] }

    { 21  ;2   ;Field     ;
                Name=Field5;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[5];
                CaptionClass='3,' + ColumnCaption[5] }

    { 25  ;2   ;Field     ;
                Name=Field6;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[6];
                CaptionClass='3,' + ColumnCaption[6] }

    { 27  ;2   ;Field     ;
                Name=Field7;
                Width=6;
                ApplicationArea=#Jobs;
                BlankZero=Yes;
                SourceExpr=CellData[7];
                CaptionClass='3,' + ColumnCaption[7] }

    { 48  ;2   ;Field     ;
                DrillDown=No;
                CaptionML=[DAN=I alt;
                           ENU=Total];
                ToolTipML=[DAN=Angiver det samlede antal timer, der er indtastet p† en arkiveret timeseddel.;
                           ENU=Specifies the total number of hours that have been entered on an archived time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Total Quantity" }

    { 1900000007;0;Container;
                ContainerType=FactBoxArea }

    { 1905767507;1;Part   ;
                Name=PeriodSummaryArcFactBox;
                ApplicationArea=#Jobs;
                PagePartID=Page964;
                Visible=TRUE;
                PartType=Page }

  }
  CODE
  {
    VAR
      TimeSheetHeaderArchive@1006 : Record 954;
      TimeSheetDetailArchive@1003 : Record 956;
      ColumnRecords@1004 : ARRAY [32] OF Record 2000000007;
      TimeSheetMgt@1007 : Codeunit 950;
      NoOfColumns@1002 : Integer;
      CellData@1001 : ARRAY [32] OF Decimal;
      ColumnCaption@1000 : ARRAY [32] OF Text[1024];
      CurrTimeSheetNo@1008 : Code[20];
      SetWanted@1009 : 'Previous,Next';

    [Internal]
    PROCEDURE SetColumns@11();
    VAR
      Calendar@1003 : Record 2000000007;
    BEGIN
      CLEAR(ColumnCaption);
      CLEAR(ColumnRecords);
      CLEAR(Calendar);
      CLEAR(NoOfColumns);

      TimeSheetHeaderArchive.GET(CurrTimeSheetNo);
      Calendar.SETRANGE("Period Type",Calendar."Period Type"::Date);
      Calendar.SETRANGE("Period Start",TimeSheetHeaderArchive."Starting Date",TimeSheetHeaderArchive."Ending Date");
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
        IF ("Line No." <> 0) AND TimeSheetDetailArchive.GET(
             "Time Sheet No.",
             "Line No.",
             ColumnRecords[i]."Period Start")
        THEN
          CellData[i] := TimeSheetDetailArchive.Quantity
        ELSE
          CellData[i] := 0;
      END;
      UpdateFactBox;
    END;

    LOCAL PROCEDURE FindTimeSheet@7(Which@1000 : Option);
    BEGIN
      CurrTimeSheetNo := TimeSheetMgt.FindTimeSheetArchive(TimeSheetHeaderArchive,Which);
      TimeSheetMgt.SetTimeSheetArchiveNo(CurrTimeSheetNo,Rec);
      UpdateControls;
    END;

    LOCAL PROCEDURE UpdateFactBox@9();
    BEGIN
      CurrPage.PeriodSummaryArcFactBox.PAGE.UpdateData(TimeSheetHeaderArchive);
    END;

    LOCAL PROCEDURE UpdateControls@12();
    BEGIN
      SetColumns;
      UpdateFactBox;
      CurrPage.UPDATE(FALSE);
    END;

    BEGIN
    END.
  }
}

