OBJECT Report 192 Suggest Fin. Charge Memo Lines
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Foresl† rentenotalinjer;
               ENU=Suggest Fin. Charge Memo Lines];
    ProcessingOnly=Yes;
    OnPreReport=BEGIN
                  CustLedgEntry.COPY(CustLedgEntry2);
                END;

  }
  DATASET
  {
    { 8733;    ;DataItem;                    ;
               DataItemTable=Table302;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Rentenota;
                                   ENU=Finance Charge Memo];
               OnPreDataItem=BEGIN
                               NoOfRecords := COUNT;
                               IF NoOfRecords = 1 THEN
                                 Window.OPEN(Text000)
                               ELSE BEGIN
                                 Window.OPEN(Text001);
                                 OldDateTime := CURRENTDATETIME;
                               END;
                             END;

               OnAfterGetRecord=BEGIN
                                  RecordNo := RecordNo + 1;
                                  CLEAR(MakeFinChrgMemo);
                                  MakeFinChrgMemo.SuggestLines("Finance Charge Memo Header",CustLedgEntry);
                                  IF NoOfRecords = 1 THEN BEGIN
                                    MakeFinChrgMemo.Code;
                                    MARK := FALSE;
                                  END ELSE BEGIN
                                    NewDateTime := CURRENTDATETIME;
                                    IF (NewDateTime - OldDateTime > 100) OR (NewDateTime < OldDateTime) THEN BEGIN
                                      NewProgress := ROUND(RecordNo / NoOfRecords * 100,1);
                                      IF NewProgress <> OldProgress THEN BEGIN
                                        Window.UPDATE(1,NewProgress * 100);
                                        OldProgress := NewProgress;
                                      END;
                                      OldDateTime := CURRENTDATETIME;
                                    END;
                                    MARK := NOT MakeFinChrgMemo.RUN;
                                  END;
                                END;

               OnPostDataItem=BEGIN
                                COMMIT;
                                Window.CLOSE;
                                MARKEDONLY := TRUE;
                                IF FIND('-') THEN
                                  IF CONFIRM(Text002,TRUE) THEN
                                    PAGE.RUNMODAL(0,"Finance Charge Memo Header");
                              END;

               ReqFilterFields=No. }

    { 9065;    ;DataItem;CustLedgEntry2      ;
               DataItemTable=Table21;
               DataItemTableView=SORTING(Customer No.);
               OnPreDataItem=BEGIN
                               CurrReport.BREAK;
                             END;

               ReqFilterFields=Document Type }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Foresl†r linjer...;ENU=Suggesting lines...';
      Text001@1001 : TextConst 'DAN=Foresl†r linjer  @1@@@@@@@@@@@@@;ENU=Suggesting lines @1@@@@@@@@@@@@@';
      Text002@1002 : TextConst 'DAN=Det var ikke muligt at behandle alle de valgte rentenotaer.\Vil du se disse rentenotaer?;ENU=It was not possible to process some of the selected finance charge memos.\Do you want to see these finance charge memos?';
      CustLedgEntry@1004 : Record 21;
      MakeFinChrgMemo@1005 : Codeunit 394;
      Window@1006 : Dialog;
      NoOfRecords@1007 : Integer;
      RecordNo@1008 : Integer;
      NewProgress@1009 : Integer;
      OldProgress@1010 : Integer;
      NewDateTime@1011 : DateTime;
      OldDateTime@1012 : DateTime;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

