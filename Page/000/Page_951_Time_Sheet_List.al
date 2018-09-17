OBJECT Page 951 Time Sheet List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Timeseddeloversigt;
               ENU=Time Sheet List];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table950;
    SourceTableView=SORTING(Resource No.,Starting Date);
    PageType=List;
    OnOpenPage=BEGIN
                 IF UserSetup.GET(USERID) THEN
                   CurrPage.EDITABLE := UserSetup."Time Sheet Admin.";
                 TimeSheetMgt.FilterTimeSheets(Rec,FIELDNO("Owner User ID"));
               END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 12      ;1   ;Action    ;
                      CaptionML=[DAN=Opret timesedler;
                                 ENU=Create Time Sheets];
                      ToolTipML=[DAN=Opret nye timesedler for ressourcer.;
                                 ENU=Create new time sheets for resources.];
                      ApplicationArea=#Jobs;
                      RunObject=Report 950;
                      Promoted=Yes;
                      Image=NewTimesheet;
                      PromotedCategory=Process }
      { 5       ;1   ;Action    ;
                      Name=EditTimeSheet;
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
      { 13      ;1   ;Action    ;
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
      { 9       ;0   ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 7       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Timeseddel;
                                 ENU=&Time Sheet];
                      ActionContainerType=RelatedInformation;
                      Image=Timesheet }
      { 8       ;2   ;Action    ;
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
      PAGE.RUN(PAGE::"Time Sheet",TimeSheetLine);
    END;

    BEGIN
    END.
  }
}

