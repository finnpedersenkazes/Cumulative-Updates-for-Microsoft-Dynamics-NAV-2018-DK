OBJECT Report 190 Issue Reminders
{
  OBJECT-PROPERTIES
  {
    Date=26-01-18;
    Time=12:00:00;
    Version List=NAVW111.00.00.20348,NAVDK11.00.00.20348;
  }
  PROPERTIES
  {
    CaptionML=[DAN=Udsted rykkere;
               ENU=Issue Reminders];
    ProcessingOnly=Yes;
    OnInitReport=VAR
                   OfficeMgt@1000 : Codeunit 1630;
                 BEGIN
                   IsOfficeAddin := OfficeMgt.IsAvailable;
                   IF IsOfficeAddin THEN
                     PrintDoc := 2;
                 END;

  }
  DATASET
  {
    { 4775;    ;DataItem;                    ;
               DataItemTable=Table295;
               DataItemTableView=SORTING(No.);
               ReqFilterHeadingML=[DAN=Rykkermeddelelse;
                                   ENU=Reminder];
               OnPreDataItem=BEGIN
                               IF ReplacePostingDate AND (PostingDateReq = 0D) THEN
                                 ERROR(Text000);
                               NoOfRecords := COUNT;
                               IF NoOfRecords = 1 THEN
                                 Window.OPEN(Text001)
                               ELSE BEGIN
                                 Window.OPEN(Text002);
                                 OldDateTime := CURRENTDATETIME;
                               END;
                             END;

               OnAfterGetRecord=BEGIN
                                  RecordNo := RecordNo + 1;
                                  CLEAR(ReminderIssue);
                                  ReminderIssue.Set("Reminder Header",ReplacePostingDate,PostingDateReq);
                                  IF NoOfRecords = 1 THEN BEGIN
                                    OIOXMLCheckReminder.RUN("Reminder Header");
                                    ReminderIssue.RUN;
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
                                    COMMIT;
                                    MARK := NOT ReminderIssue.RUN;
                                  END;

                                  IF PrintDoc <> PrintDoc::" " THEN BEGIN
                                    ReminderIssue.GetIssuedReminder(IssuedReminderHeader);
                                    TempIssuedReminderHeader := IssuedReminderHeader;
                                    TempIssuedReminderHeader.INSERT;
                                  END;
                                END;

               OnPostDataItem=VAR
                                IssuedReminderHeaderPrint@1000 : Record 297;
                              BEGIN
                                Window.CLOSE;
                                COMMIT;
                                IF PrintDoc <> PrintDoc::" " THEN
                                  IF TempIssuedReminderHeader.FINDSET THEN
                                    REPEAT
                                      IssuedReminderHeaderPrint := TempIssuedReminderHeader;
                                      IssuedReminderHeaderPrint.SETRECFILTER;
                                      IssuedReminderHeaderPrint.PrintRecords(FALSE,PrintDoc = PrintDoc::Email,HideDialog);
                                    UNTIL TempIssuedReminderHeader.NEXT = 0;
                                MARKEDONLY := TRUE;
                                IF FIND('-') THEN
                                  IF CONFIRM(Text003,TRUE) THEN
                                    PAGE.RUNMODAL(0,"Reminder Header");
                              END;

               ReqFilterFields=No. }

  }
  REQUESTPAGE
  {
    PROPERTIES
    {
      SaveValues=Yes;
    }
    CONTROLS
    {
      { 1900000001;0;Container;
                  ContainerType=ContentArea }

      { 1900000002;1;Group  ;
                  CaptionML=[DAN=Indstillinger;
                             ENU=Options] }

      { 3   ;2   ;Field     ;
                  Name=PrintDoc;
                  CaptionML=[DAN=Udskriv;
                             ENU=Print];
                  ToolTipML=[DAN=Angiver, om du vil udskrive eller maile rykkerne, n†r de udstedes.;
                             ENU=Specifies it you want to print or email the reminders when they are issued.];
                  ApplicationArea=#Advanced;
                  SourceExpr=PrintDoc;
                  Enabled=NOT IsOfficeAddin }

      { 2   ;2   ;Field     ;
                  CaptionML=[DAN=Erstat bogf›ringsdato;
                             ENU=Replace Posting Date];
                  ToolTipML=[DAN=Angiver, om du vil erstatte rykkerens bogf›ringsdato med den dato, der er angivet i feltet nedenfor.;
                             ENU=Specifies if you want to replace the reminders' posting date with the date entered in the field below.];
                  ApplicationArea=#Advanced;
                  SourceExpr=ReplacePostingDate }

      { 1   ;2   ;Field     ;
                  CaptionML=[DAN=Bogf›ringsdato;
                             ENU=Posting Date];
                  ToolTipML=[DAN=Angiver bogf›ringsdatoen. Hvis du markerer afkrydsningsfeltet herover, bruges denne dato p† alle rykkere, n†r du bogf›rer.;
                             ENU=Specifies the posting date. If you place a check mark in the check box above, the program will use this date on all reminders when you post.];
                  ApplicationArea=#Advanced;
                  SourceExpr=PostingDateReq }

      { 4   ;2   ;Field     ;
                  Name=HideEmailDialog;
                  CaptionML=[DAN=Skjul maildialogboks;
                             ENU=Hide Email Dialog];
                  ToolTipML=[DAN=Angiver, om du vil skjule maildialogboksen.;
                             ENU=Specifies if you want to hide email dialog.];
                  ApplicationArea=#Advanced;
                  SourceExpr=HideDialog }

    }
  }
  LABELS
  {
  }
  CODE
  {
    VAR
      Text000@1000 : TextConst 'DAN=Angiv bogf›ringsdatoen.;ENU=Enter the posting date.';
      Text001@1001 : TextConst 'DAN=Udsteder rykker...;ENU=Issuing reminder...';
      Text002@1002 : TextConst 'DAN=Udsteder rykkere  @1@@@@@@@@@@@@@;ENU=Issuing reminders @1@@@@@@@@@@@@@';
      Text003@1003 : TextConst 'DAN=Det var ikke muligt at udstede alle de valgte rykkere.\Vil du se disse rykkere?;ENU=It was not possible to issue some of the selected reminders.\Do you want to see these reminders?';
      IssuedReminderHeader@1005 : Record 297;
      TempIssuedReminderHeader@1017 : TEMPORARY Record 297;
      ReminderIssue@1006 : Codeunit 393;
      OIOXMLCheckReminder@1101100000 : Codeunit 13604;
      Window@1007 : Dialog;
      NoOfRecords@1008 : Integer;
      RecordNo@1009 : Integer;
      NewProgress@1010 : Integer;
      OldProgress@1011 : Integer;
      NewDateTime@1012 : DateTime;
      OldDateTime@1013 : DateTime;
      PostingDateReq@1014 : Date;
      ReplacePostingDate@1015 : Boolean;
      PrintDoc@1016 : ' ,Print,Email';
      HideDialog@1004 : Boolean;
      IsOfficeAddin@1018 : Boolean INDATASET;

    BEGIN
    END.
  }
  RDLDATA
  {
  }
}

