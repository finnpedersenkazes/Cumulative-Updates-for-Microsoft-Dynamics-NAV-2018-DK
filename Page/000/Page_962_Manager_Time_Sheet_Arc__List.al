OBJECT Page 962 Manager Time Sheet Arc. List
{
  OBJECT-PROPERTIES
  {
    Date=21-12-17;
    Time=12:00:00;
    Version List=NAVW111.00.00.19846;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Arkivoversigt for leders timesedler;
               ENU=Manager Time Sheet Arc. List];
    InsertAllowed=No;
    ModifyAllowed=No;
    SourceTable=Table954;
    SourceTableView=SORTING(Resource No.,Starting Date);
    PageType=List;
    OnOpenPage=BEGIN
                 IF UserSetup.GET(USERID) THEN
                   CurrPage.EDITABLE := UserSetup."Time Sheet Admin.";
                 TimeSheetMgt.FilterTimeSheetsArchive(Rec,FIELDNO("Approver User ID"));
               END;

    ActionList=ACTIONS
    {
      { 3       ;    ;ActionContainer;
                      ActionContainerType=ActionItems }
      { 5       ;1   ;Action    ;
                      ShortCutKey=Return;
                      CaptionML=[DAN=&Vis timeseddel;
                                 ENU=&View Time Sheet];
                      ToolTipML=[DAN=èbn timesedlen.;
                                 ENU=Open the time sheet.];
                      ApplicationArea=#Jobs;
                      Promoted=Yes;
                      PromotedIsBig=Yes;
                      Image=OpenJournal;
                      PromotedCategory=Process;
                      OnAction=BEGIN
                                 EditTimeSheet;
                               END;
                                }
      { 7       ;    ;ActionContainer;
                      ActionContainerType=RelatedInformation }
      { 8       ;1   ;ActionGroup;
                      CaptionML=[DAN=&Timeseddel;
                                 ENU=&Time Sheet];
                      Image=Timesheet }
      { 9       ;2   ;Action    ;
                      CaptionML=[DAN=Be&mërkninger;
                                 ENU=Co&mments];
                      ToolTipML=[DAN=Se eller tilfõj bemërkninger for recorden.;
                                 ENU=View or add comments for the record.];
                      ApplicationArea=#Advanced;
                      RunObject=Page 963;
                      RunPageLink=No.=FIELD(No.),
                                  Time Sheet Line No.=CONST(0);
                      Image=ViewComments }
      { 10      ;2   ;Action    ;
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
                ToolTipML=[DAN=Angiver startdatoen for den arkiverede timeseddel.;
                           ENU=Specifies the start date for the archived time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Starting Date" }

    { 4   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver slutdatoen for en arkiveret timeseddel.;
                           ENU=Specifies the end date for an archived time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Ending Date" }

    { 6   ;2   ;Field     ;
                ToolTipML=[DAN=Angiver listen over ressourcenumre, som er knyttet til en arkiveret timeseddel.;
                           ENU=Specifies the list of resource numbers associated with an archived time sheet.];
                ApplicationArea=#Jobs;
                SourceExpr="Resource No." }

  }
  CODE
  {
    VAR
      UserSetup@1001 : Record 91;
      TimeSheetMgt@1000 : Codeunit 950;

    LOCAL PROCEDURE EditTimeSheet@1();
    VAR
      TimeSheetLineArchive@1001 : Record 955;
    BEGIN
      TimeSheetMgt.SetTimeSheetArchiveNo("No.",TimeSheetLineArchive);
      PAGE.RUN(PAGE::"Manager Time Sheet Archive",TimeSheetLineArchive);
    END;

    BEGIN
    END.
  }
}

