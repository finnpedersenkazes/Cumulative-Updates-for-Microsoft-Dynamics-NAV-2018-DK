OBJECT Page 953 Manager Time Sheet List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Leders timeseddeloversigt;
               ENU=Manager Time Sheet List];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table950;
    SourceTableView=SORTING(Resource No.,Starting Date);
    PageType=List;
    RefreshOnActivate=Yes;
    OnOpenPage=BEGIN
                 IF UserSetup.GET(USERID) THEN
                   CurrPage.EDITABLE := UserSetup."Time Sheet Admin.";
                 TimeSheetMgt.FilterTimeSheets(Rec,FIELDNO("Approver User ID"));
               END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=&Rediger timeseddel;
                                 ENU=&Edit Time Sheet];
                      ToolTipML=[DAN=èbn timesedlen i redigeringstilstand.;
                                 ENU=Open the time sheet in edit mode.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 EditTimeSheet;
                               END;
                                }
      { 18      ;1   ;Action    ;
                      Name=MoveTimeSheetsToArchive;
                      CaptionML=[DAN=Flyt timesedler til arkiv;
                                 ENU=Move Time Sheets to Archive];
                      ToolTipML=[DAN=ArkivÇr timesedler.;
                                 ENU=Archive time sheets.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 953;
                      Promoted=Yes;
                      Image=Archive;
                      PromotedCategory=Process }
      { 7       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Timeseddel;
                                 ENU=&Time Sheet];
                      Image=Timesheet }
      { 9       ;2   ;Action    ;
                      Name=Comments;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 955;
                      RunPageLink=No.=FIELD(No.),
                                  Time Sheet Line No.=CONST(0);
                      Image=ViewComments }
      { 16      ;2   ;Action    ;
                      ShortCutKey=Ctrl+F7;
                      CaptionML=[DAN=Bogfõrer p&oster;
                                 ENU=Posting E&ntries];
                      ToolTipML=[DAN=Vis de ressourceposter, der er bogfõrt i forbindelse med timesedlen.;
                                 ENU=View the resource ledger entries that have been posted in connection with the.];
                      ApplicationArea=#Jobs;
                      RunObject=Page 958;
                      RunPageLink=Time Sheet No.=FIELD(No.);
                      Image=PostingEntries }
    }
  }
  CONTROLS
  {
    { 1900000001;0;Container;
                ContainerType=ContentArea }

    { 1   ;1   ;Group     ;
                GroupType=Repeater }

    { 11  ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ den tilknyttede post eller record i overensstemmelse med den angivne nummerserie.;
                           ENU=Specifies the number of the involved entry or record, according to the specified number series.];
                ApplicationArea=#Jobs;
                SourceExpr="No." }

    { 2   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver startdatoen for en timeseddel.;
                           ENU=Specifies the starting date for a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Starting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for en timeseddel.;
                           ENU=Specifies the ending date for a time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Ending Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver nummeret pÜ ressourcen for timesedlen.;
                           ENU=Specifies the number of the resource for the time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource No." }

    { 10  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, om der er timeseddellinjer med statussen èben.;
                           ENU=Specifies if there are time sheet lines with the status Open.];
                ApplicationArea=#Jobs;
                SourceExpr="Open Exists" }

    { 12  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, om der er timeseddellinjer med statussen Sendt.;
                           ENU=Specifies if there are time sheet lines with the status Submitted.];
                ApplicationArea=#Jobs;
                SourceExpr="Submitted Exists" }

    { 13  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, om der er timeseddellinjer med statussen Afvist.;
                           ENU=Specifies whether there are time sheet lines with the status Rejected.];
                ApplicationArea=#Jobs;
                SourceExpr="Rejected Exists" }

    { 14  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, om der er timeseddellinjer med statussen Godkendt.;
                           ENU=Specifies whether there are time sheet lines with the status Approved.];
                ApplicationArea=#Jobs;
                SourceExpr="Approved Exists" }

    { 15  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, om der er timeseddellinjer med statussen Bogfõrt.;
                           ENU=Specifies whether there are time sheet lines with the status Posted.];
                ApplicationArea=#Jobs;
                SourceExpr="Posted Exists" }

    { 17  ;2   ;Field     ;
                DrillDown=No;
                ToolTipML=[DAN=Angiver, at der er indtastet en bemërkning om dette dokument.;
                           ENU=Specifies that a comment about this document has been entered.];
                ApplicationArea=#Advanced;
                SourceExpr=Comment }

  }
  CODE
  {
    VAR
      UserSetup@1001 : Record 91;
      TimeSheetMgt@1000 : Codeunit 950;

    LOCAL PROCEDURE EditTimeSheet@1();
    VAR
      TimeSheetLine@1001 : Record 951;
    BEGIN
      TimeSheetMgt.SetTimeSheetNo("No.",TimeSheetLine);
      PAGE.RUN(PAGE::"Manager Time Sheet",TimeSheetLine);
    END;

    BEGIN
    END.
  }
}

